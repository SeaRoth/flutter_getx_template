# Flutter GetX Template

 Flutter project template to quickly spin up apps using [GetX 5 RC 5](https://github.com/jonataslaw/getx/tree/latest-getx5-RC))

 | Home          | Details       | Add           | Friends       | Settings      |
 | ------------- | ------------- | ------------- | ------------- | ------------- |
 | ![Home](https://github.com/user-attachments/assets/d04da633-e6f9-4482-b5c8-512f950b8f06) | ![Details](https://github.com/user-attachments/assets/b5b9b193-bae2-4450-8fae-e1319ef56b98) | ![Add](https://github.com/user-attachments/assets/de6392e2-7b2c-4124-9dfd-ef8f758d8c37) | ![Friends](https://github.com/user-attachments/assets/117da5a3-08c5-41c2-b694-f6aeaeb98ce4) | ![Settings](https://github.com/user-attachments/assets/736077f0-1905-4ba3-aac6-59bbdc91373e) |

# Includes:
1. Unique pages
2. Bottom sheet implementation
3. Settings page
4. Widgets that save state using shared preferences
5. Bottom sheet implementation

# How to run:
1. Download project
2. Open terminal at project, type: `flutter pub get`
3. Turn on emulator/device
4. Run it

# 🚀 Quick Project Creation (Automated)

Use the automated script to quickly create a new project from this template:

```bash
./create_new_project.sh
```

The script will:
1. 📝 Prompt you for a project name and package name
2. 📁 Create a new project folder with your chosen name
3. 📋 Copy all template files (excluding build artifacts and git history)
4. 📦 Automatically change the package name using `change_app_package_name`
5. 🔄 Run `flutter pub get` and clean up generated files
6. ✅ Leave you with a ready-to-run Flutter project

**Example usage:**
```bash
$ ./create_new_project.sh
Enter the new project name: my_awesome_app
Enter the package name: com.mycompany.myawesomeapp
Enter the parent directory path: /Users/username/Projects
```

# 🔧 Manual Setup

If you prefer to set up manually:

## Change package name and app name:
- Uses [change_app_package_name](https://pub.dev/packages/change_app_package_name)

### Run this command to change the package name for both platforms:
```bash
dart run change_app_package_name:main com.new.package.name
```

# Add a custom submodule 
`git submodule add https://github.com/org/repo.git`