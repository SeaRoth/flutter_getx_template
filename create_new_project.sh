#!/bin/bash

# Flutter GetX Template Project Creator
# This script creates a new Flutter project from the GetX template

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get current directory (template directory)
TEMPLATE_DIR=$(pwd)
TEMPLATE_NAME=$(basename "$TEMPLATE_DIR")

echo -e "${GREEN}🚀 Flutter GetX Template Project Creator${NC}"
echo "============================================"

# Prompt for project name
while true; do
    read -p "Enter the new project name (folder name): " PROJECT_NAME
    if [[ -z "$PROJECT_NAME" ]]; then
        print_error "Project name cannot be empty!"
        continue
    fi
    
    # Validate project name (Flutter naming conventions)
    if [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
        print_error "Project name must be lowercase, start with a letter, and contain only letters, numbers, and underscores!"
        continue
    fi
    
    break
done

# Prompt for package name
while true; do
    read -p "Enter the package name (e.g., com.yourcompany.projectname): " PACKAGE_NAME
    if [[ -z "$PACKAGE_NAME" ]]; then
        print_error "Package name cannot be empty!"
        continue
    fi
    
    # Basic validation for package name
    if [[ ! "$PACKAGE_NAME" =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$ ]]; then
        print_error "Package name must follow reverse domain notation (e.g., com.company.appname)!"
        continue
    fi
    
    break
done

# Determine target directory
read -p "Enter the parent directory path (or press Enter for current directory): " PARENT_DIR
if [[ -z "$PARENT_DIR" ]]; then
    PARENT_DIR="."
fi

TARGET_DIR="$PARENT_DIR/$PROJECT_NAME"

# Check if target directory already exists
if [[ -d "$TARGET_DIR" ]]; then
    read -p "Directory '$TARGET_DIR' already exists. Overwrite? (y/N): " OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
        print_error "Operation cancelled."
        exit 1
    fi
    print_warning "Removing existing directory..."
    rm -rf "$TARGET_DIR"
fi

print_status "Creating new project '$PROJECT_NAME' in '$TARGET_DIR'..."

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy template files (excluding build artifacts, git, and IDE files)
print_status "Copying template files..."
rsync -av \
    --exclude='.git/' \
    --exclude='build/' \
    --exclude='.dart_tool/' \
    --exclude='.idea/' \
    --exclude='.vscode/' \
    --exclude='*.iml' \
    --exclude='.flutter-plugins' \
    --exclude='.flutter-plugins-dependencies' \
    --exclude='.packages' \
    --exclude='pubspec.lock' \
    --exclude='ios/Pods/' \
    --exclude='ios/.symlinks/' \
    --exclude='android/.gradle/' \
    --exclude='android/app/build/' \
    --exclude='android/build/' \
    --exclude='android/app/.cxx/' \
    --exclude='*.log' \
    "$TEMPLATE_DIR/" "$TARGET_DIR/"

print_success "Template files copied successfully!"

# Navigate to the new project directory
cd "$TARGET_DIR"

# Update pubspec.yaml with new project name
print_status "Updating pubspec.yaml with new project name..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/name: $TEMPLATE_NAME/name: $PROJECT_NAME/" pubspec.yaml
else
    # Linux
    sed -i "s/name: $TEMPLATE_NAME/name: $PROJECT_NAME/" pubspec.yaml
fi

# Update all Dart file imports to use the new project name
print_status "Updating package imports in Dart files..."
find . -name "*.dart" -type f -exec grep -l "package:$TEMPLATE_NAME/" {} \; | while read -r file; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/package:$TEMPLATE_NAME\//package:$PROJECT_NAME\//g" "$file"
    else
        # Linux
        sed -i "s/package:$TEMPLATE_NAME\//package:$PROJECT_NAME\//g" "$file"
    fi
    print_status "Updated imports in: $file"
done

# Get Flutter dependencies
print_status "Running 'flutter pub get'..."
flutter pub get

# Change package name using the dart package
print_status "Changing package name to '$PACKAGE_NAME'..."
dart run change_app_package_name:main "$PACKAGE_NAME"

# Clean up any generated files that might have old references
print_status "Cleaning up generated files..."
flutter clean
flutter pub get

print_success "🎉 Project '$PROJECT_NAME' created successfully!"
echo ""
echo "Project details:"
echo "  📁 Location: $TARGET_DIR"
echo "  📦 Package: $PACKAGE_NAME"
echo "  🚀 Ready to run: cd $PROJECT_NAME && flutter run"
echo ""
print_status "Next steps:"
echo "  1. cd $PROJECT_NAME"
echo "  2. flutter run (make sure you have a device/emulator running)"
echo "  3. Start building your awesome app! 🎯"