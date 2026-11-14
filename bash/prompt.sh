# Track whether a command was actually run since the last prompt
__prompt_ran_cmd=1
trap '__prompt_ran_cmd=1' DEBUG

__last_git_dir=""
__last_git_dirty=0

__build_prompt() {
    # Gruvbox TrueColor ANSI escapes
    local c_yellow='\[\e[3;38;2;250;189;47m\]' # Italic #fabd2f
    local c_gray='\[\e[38;2;168;153;132m\]'    # #a89984
    local c_green='\[\e[38;2;184;187;38m\]'    # #b8bb26
    local c_blue='\[\e[38;2;131;165;152m\]'    # #83a598
    local c_purple='\[\e[38;2;211;134;155m\]'  # #d3869b
    local c_reset='\[\e[0m\]'

    local out=""
    local has_cmake=0 has_mvn=0 git_dir=""

    # 1. Walk upward once to detect CMakeLists.txt, pom.xml, and .git
    local dir="$PWD"
    while [[ -n "$dir" ]]; do
        [[ $has_cmake -eq 0 && -f "$dir/CMakeLists.txt" ]] && has_cmake=1
        [[ $has_mvn -eq 0 && -f "$dir/pom.xml" ]] && has_mvn=1
        if [[ -z "$git_dir" && -e "$dir/.git" ]]; then
            if [[ -d "$dir/.git" ]]; then
                git_dir="$dir/.git"
            elif [[ -f "$dir/.git" ]]; then
                local gitfile
                IFS= read -r gitfile < "$dir/.git"
                git_dir="${gitfile#gitdir: }"
                [[ "$git_dir" != /* ]] && git_dir="$dir/$git_dir"
            fi
        fi
        [[ $has_cmake -eq 1 && $has_mvn -eq 1 && -n "$git_dir" ]] && break
        [[ "$dir" == "/" ]] && break
        dir="${dir%/*}"
        [[ -z "$dir" ]] && dir="/"
    done

    # 2. Toolchain & Python Virtualenv
    [[ $has_cmake -eq 1 ]] && out+="${c_yellow}cmake ${c_reset}"
    [[ $has_mvn -eq 1 ]] && out+="${c_yellow}mvn ${c_reset}"
    [[ -n "$VIRTUAL_ENV" ]] && out+="${c_yellow}${VIRTUAL_ENV##*/} ${c_reset}"

    # 3. Character & Current Working Directory name only
    out+="${c_gray}➜ ${c_reset}"
    local short_dir="${PWD/#$HOME/\~}"
    [[ "$short_dir" != "/" && "$short_dir" != "~" ]] && short_dir="${short_dir##*/}"
    out+="${c_green}${short_dir}${c_reset}"

    # 4. Git Section
    if [[ -n "$git_dir" && -f "$git_dir/HEAD" ]]; then
        local head branch="" raw_branch="" local_sha=""
        IFS= read -r head < "$git_dir/HEAD"

        # A. Branch or Detached Commit (Pure .git read)
        if [[ "$head" == ref:\ * ]]; then
            raw_branch="${head#ref: refs/heads/}"
            branch="$raw_branch"
            if [[ -f "$git_dir/refs/heads/$raw_branch" ]]; then
                IFS= read -r local_sha < "$git_dir/refs/heads/$raw_branch"
            elif [[ -f "$git_dir/packed-refs" ]]; then
                while IFS= read -r line; do
                    if [[ "$line" == *" refs/heads/$raw_branch" ]]; then
                        local_sha="${line%% *}"
                        break
                    fi
                done < "$git_dir/packed-refs"
            fi
            (( ${#branch} > 8 )) && branch="${branch:0:8}…"
            out+="(${c_blue}${branch}${c_reset}"
        else
            out+="(${c_blue}${head:0:7}${c_reset}"
        fi

        # B. Local vs Origin Divergence '~' (Pure .git read)
        local indicators=""
        if [[ -n "$local_sha" && -n "$raw_branch" ]]; then
            local origin_sha=""
            if [[ -f "$git_dir/refs/remotes/origin/$raw_branch" ]]; then
                IFS= read -r origin_sha < "$git_dir/refs/remotes/origin/$raw_branch"
            elif [[ -f "$git_dir/packed-refs" ]]; then
                while IFS= read -r line; do
                    if [[ "$line" == *" refs/remotes/origin/$raw_branch" ]]; then
                        origin_sha="${line%% *}"
                        break
                    fi
                done < "$git_dir/packed-refs"
            fi
            if [[ -n "$origin_sha" && "$local_sha" != "$origin_sha" ]]; then
                indicators+="~"
            fi
        fi

        # C. Ultra-Fast Status Check '*' (Git State + Working Tree)
        local is_dirty=0
        if [[ -f "$git_dir/index.lock" || -d "$git_dir/rebase-merge" || \
              -d "$git_dir/rebase-apply" || -f "$git_dir/MERGE_HEAD" || \
              -f "$git_dir/REVERT_HEAD" || -f "$git_dir/CHERRY_PICK_HEAD" || \
              -f "$git_dir/BISECT_LOG" ]]; then
            # Tier 1: Active git state or index lock (~0ms, pure Bash)
            is_dirty=1
        elif [[ "$git_dir" == "$__last_git_dir" && $__prompt_ran_cmd -eq 0 ]]; then
            # Tier 2: Empty Enter pressed in same repo (~0ms, cached)
            is_dirty=$__last_git_dirty
        else
            # Tier 3: Single git call, reads 1 byte & stops immediately (~1-3ms)
            local first_char=""
            IFS= read -rn 1 first_char < <(git status --porcelain -unormal --ignore-submodules=dirty 2>/dev/null)
            [[ -n "$first_char" ]] && is_dirty=1
        fi

        __last_git_dir="$git_dir"
        __last_git_dirty=$is_dirty
        [[ $is_dirty -eq 1 ]] && indicators+="*"

        # D. Stash check '=' (Pure .git check)
        [[ -f "$git_dir/refs/stash" ]] && indicators+="="

        [[ -n "$indicators" ]] && out+="${c_purple}${indicators}${c_reset}"
        out+=") "
    else
        __last_git_dir=""
        __last_git_dirty=0
        out+=" "
    fi

    __prompt_ran_cmd=0
    PS1="$out"
}

PROMPT_COMMAND=__build_prompt
