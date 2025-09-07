#!/bin/bash

# Enhanced Application Bundle ID Extractor
# This script extracts application bundle IDs and creates a JSON file
# with improved user experience and error handling

# Color definitions for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Unicode symbols for better visual appeal
CHECKMARK="✅"
CROSS="❌"
GEAR="⚙️"
ROCKET="🚀"
FOLDER="📁"
FILE="📄"

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print header
print_header() {
    echo
    print_color $CYAN "╔══════════════════════════════════════════════════════════════╗"
    print_color $CYAN "║                ${WHITE}Application Bundle ID Extractor${CYAN}                ║"
    print_color $CYAN "╚══════════════════════════════════════════════════════════════╝"
    echo
}

# Function to show help
show_help() {
    print_header
    print_color $WHITE "使用方法:"
    echo
    print_color $GREEN "  $0                                    ${WHITE}Bundle IDを抽出してJSONファイルを作成"
    print_color $GREEN "  $0 --export <出力ファイル>           ${WHITE}defaults exportコマンドをスクリプトファイルに出力"
    print_color $GREEN "  $0 --export-plist <出力ディレクトリ> ${WHITE}plistファイルを直接ディレクトリに出力"
    print_color $GREEN "  $0 --help                            ${WHITE}このヘルプを表示"
    echo
    print_color $WHITE "例:"
    echo
    print_color $YELLOW "  $0"
    print_color $BLUE "    → Applications.jsonを作成"
    echo
    print_color $YELLOW "  $0 --export .chezmoiscripts/run_onchange_after_10-defaults.sh"
    print_color $BLUE "    → defaults exportコマンドをスクリプトに出力"
    echo
    print_color $YELLOW "  $0 --export-plist config"
    print_color $BLUE "    → 全アプリケーションのplistファイルをconfigディレクトリに出力"
    echo
}

# Function to show spinner
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to check dependencies
check_dependencies() {
    print_color $BLUE "${GEAR} 依存関係をチェック中..."

    if ! command -v jq &> /dev/null; then
        print_color $RED "${CROSS} エラー: jq がインストールされていません"
        print_color $YELLOW "  Homebrew でインストールしてください: brew install jq"
        exit 1
    fi

    if ! command -v mdls &> /dev/null; then
        print_color $RED "${CROSS} エラー: mdls コマンドが見つかりません"
        exit 1
    fi

    print_color $GREEN "${CHECKMARK} 依存関係チェック完了"
}

# Function to count applications
count_applications() {
    local count=0
    for app in /Applications/*.app; do
        if [[ -d "$app" ]]; then
            ((count++))
        fi
    done
    echo $count
}

# Function to create progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    local remaining=$((width - completed))

    printf "\r${BLUE}進捗: [${GREEN}"
    printf "%*s" $completed | tr ' ' '█'
    printf "${WHITE}"
    printf "%*s" $remaining | tr ' ' '░'
    printf "${BLUE}] ${WHITE}%d%%${NC} (%d/%d)" $percentage $current $total
}

# Function to export defaults commands
export_defaults() {
    local output_file="$1"

    print_color $BLUE "${GEAR} defaults コマンドを生成中..."

    # Create temporary file for defaults commands
    temp_defaults=$(mktemp)

    # Get current applications and generate defaults commands
    for app in /Applications/*.app; do
        if [[ -d "$app" ]]; then
            bundle_id=$(mdls -name kMDItemCFBundleIdentifier -r "$app" 2>/dev/null)

            if [[ "$bundle_id" != "(null)" && -n "$bundle_id" && "$bundle_id" != "" ]]; then
                # Generate defaults export command for each bundle ID
                echo "# Import settings for $bundle_id" >> "$temp_defaults"
                echo "defaults import $bundle_id \$DIR/config/${bundle_id}_settings.plist" >> "$temp_defaults"
                echo "killall $bundle_id" >> "$temp_defaults"
                echo "" >> "$temp_defaults"
            fi
        fi
    done

    # Write to output file
    if [[ -s "$temp_defaults" ]]; then
        cat "$temp_defaults" > "$output_file"
        print_color $GREEN "${CHECKMARK} defaults コマンドを $output_file に出力しました"
    else
        print_color $YELLOW "${CROSS} 有効な Bundle ID が見つかりませんでした"
    fi

    # Cleanup
    rm -f "$temp_defaults"
}

# Function to export plist files directly
export_plist_files() {
    local config_dir="$1"

    print_color $BLUE "${GEAR} plistファイルを直接出力中..."

    # Create config directory if it doesn't exist
    mkdir -p "$config_dir"

    # Initialize counters
    local current_app=0
    local exported_count=0
    local failed_count=0

    # Count total applications first
    local total_apps=$(count_applications)

    if [[ $total_apps -eq 0 ]]; then
        print_color $YELLOW "${CROSS} 警告: /Applications にアプリケーションが見つかりませんでした"
        return 0
    fi

    print_color $GREEN "${CHECKMARK} ${total_apps} 個のアプリケーションを発見"
    echo

    # Process applications with progress bar
    for app in /Applications/*.app; do
        if [[ -d "$app" ]]; then
            ((current_app++))
            progress_bar $current_app $total_apps

            bundle_id=$(mdls -name kMDItemCFBundleIdentifier -r "$app" 2>/dev/null)

            if [[ "$bundle_id" != "(null)" && -n "$bundle_id" && "$bundle_id" != "" ]]; then
                # Export settings to plist file
                plist_file="$config_dir/${bundle_id}_settings.plist"
                if defaults export "$bundle_id" "$plist_file" 2>/dev/null; then
                    ((exported_count++))
                else
                    ((failed_count++))
                fi
            else
                ((failed_count++))
            fi
        fi
    done

    echo # New line after progress bar

    # Print summary
    print_color $GREEN "${CHECKMARK} plistファイルの出力が完了しました"
    print_color $BLUE "${FILE} 出力先: $config_dir"
    print_color $GREEN "${CHECKMARK} 成功: $exported_count ファイル"
    if [[ $failed_count -gt 0 ]]; then
        print_color $YELLOW "${CROSS} 失敗: $failed_count ファイル"
    fi
}

# Check for --help flag
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    show_help
    exit 0
fi

# Check for --export flag
if [[ "${1:-}" == "--export" ]]; then
    if [[ -z "${2:-}" ]]; then
        print_color $RED "${CROSS} エラー: 出力ファイルを指定してください"
        print_color $YELLOW "使用方法: $0 --export <出力ファイル>"
        exit 1
    fi

    print_header
    check_dependencies
    export_defaults "$2"
    exit 0
fi

# Check for --export-plist flag
if [[ "${1:-}" == "--export-plist" ]]; then
    if [[ -z "${2:-}" ]]; then
        print_color $RED "${CROSS} エラー: 出力ディレクトリを指定してください"
        print_color $YELLOW "使用方法: $0 --export-plist <出力ディレクトリ>"
        exit 1
    fi

    print_header
    check_dependencies
    export_plist_files "$2"
    exit 0
fi

# Main execution starts here
print_header

# Record start time
start_time=$(date +%s)

# Check dependencies
check_dependencies

# Check if Applications directory exists
if [[ ! -d "/Applications" ]]; then
    print_color $RED "${CROSS} エラー: /Applications ディレクトリが見つかりません"
    exit 1
fi

print_color $BLUE "${FOLDER} /Applications ディレクトリをスキャン中..."

# Count total applications
total_apps=$(count_applications)

if [[ $total_apps -eq 0 ]]; then
    print_color $YELLOW "${CROSS} 警告: /Applications にアプリケーションが見つかりませんでした"
    exit 0
fi

print_color $GREEN "${CHECKMARK} ${total_apps} 個のアプリケーションを発見"
echo

print_color $BLUE "${GEAR} Bundle ID を抽出中..."

# Initialize counters
current_app=0
valid_bundles=0
invalid_bundles=0

# Create temporary file for bundle IDs
temp_file=$(mktemp)

# Process applications with progress bar
for app in /Applications/*.app; do
    if [[ -d "$app" ]]; then
        ((current_app++))
        progress_bar $current_app $total_apps

        bundle_id=$(mdls -name kMDItemCFBundleIdentifier -r "$app" 2>/dev/null)

        if [[ "$bundle_id" != "(null)" && -n "$bundle_id" && "$bundle_id" != "" ]]; then
            echo "$bundle_id" >> "$temp_file"
            ((valid_bundles++))
        else
            ((invalid_bundles++))
        fi
    fi
done

echo # New line after progress bar

# Convert to JSON
print_color $BLUE "${FILE} JSON ファイルを生成中..."

if [[ -s "$temp_file" ]]; then
    cat "$temp_file" | jq -R . | jq -s . > Applications.json
    if [[ $? -eq 0 ]]; then
        print_color $GREEN "${CHECKMARK} Applications.json を正常に作成しました"
    else
        print_color $RED "${CROSS} JSON ファイルの作成に失敗しました"
        rm -f "$temp_file"
        exit 1
    fi
else
    print_color $YELLOW "${CROSS} 有効な Bundle ID が見つかりませんでした"
    echo "[]" > Applications.json
fi

# Cleanup
rm -f "$temp_file"

# Calculate execution time
end_time=$(date +%s)
execution_time=$((end_time - start_time))

# Print summary
echo
print_color $CYAN "╔══════════════════════════════════════════════════════════════╗"
print_color $CYAN "║                           ${WHITE}実行結果${CYAN}                           ║"
print_color $CYAN "╠══════════════════════════════════════════════════════════════╣"
print_color $CYAN "║ ${WHITE}スキャンしたアプリ数:${NC}   ${GREEN}$(printf "%2d" $total_apps)${CYAN}                                ║"
print_color $CYAN "║ ${WHITE}有効な Bundle ID:${NC}      ${GREEN}$(printf "%2d" $valid_bundles)${CYAN}                                ║"
print_color $CYAN "║ ${WHITE}無効な Bundle ID:${NC}      ${YELLOW}$(printf "%2d" $invalid_bundles)${CYAN}                                ║"
print_color $CYAN "║ ${WHITE}実行時間:${NC}              ${PURPLE}$(printf "%2d" $execution_time) 秒${CYAN}                              ║"
print_color $CYAN "║ ${WHITE}出力ファイル:${NC}          ${BLUE}Applications.json${CYAN}                      ║"
print_color $CYAN "╚══════════════════════════════════════════════════════════════╝"
echo

print_color $GREEN "${ROCKET} 処理が完了しました！"

# Show file size and location
if [[ -f "Applications.json" ]]; then
    file_size=$(ls -lh Applications.json | awk '{print $5}')
    print_color $BLUE "${FILE} ファイルサイズ: ${file_size}"
    print_color $BLUE "${FOLDER} 保存場所: $(pwd)/Applications.json"
fi

echo
