#!/bin/bash

# Flutter GetX Template Manager
# This script can create new projects OR add modules to existing projects

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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

print_header() {
    echo -e "${CYAN}$1${NC}"
}

# Get current directory (template directory)
TEMPLATE_DIR=$(pwd)
TEMPLATE_NAME=$(basename "$TEMPLATE_DIR")

echo -e "${GREEN}🚀 Flutter GetX Template Manager${NC}"
echo "========================================"
echo ""
print_header "What would you like to do?"
echo "1. 📁 Create a new Flutter project from template"
echo "2. ⚙️  Add a new module to existing project"
echo ""

# Main menu selection
while true; do
    read -p "Choose an option (1 or 2): " CHOICE
    case $CHOICE in
        1)
            print_header "Creating a new Flutter project..."
            break
            ;;
        2)
            print_header "Adding a module to existing project..."
            break
            ;;
        *)
            print_error "Invalid choice. Please enter 1 or 2."
            ;;
    esac
done

# Function to create new project (existing functionality)
create_new_project() {
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
}

# Function to add new module
add_new_module() {
    # Check if we're in a Flutter project
    if [[ ! -f "pubspec.yaml" ]]; then
        print_error "Not in a Flutter project directory! Please run this from your Flutter project root."
        exit 1
    fi

    # Get project name from pubspec.yaml
    PROJECT_NAME=$(grep "^name:" pubspec.yaml | cut -d' ' -f2)
    
    print_status "Current project: $PROJECT_NAME"
    echo ""
    
    print_header "Available module types:"
    echo "1. 📱 UI Module (views, controllers, bindings)"
    echo "2. 🌐 Networking Module (API services, models, repositories)"
    echo "3. 💾 Data Module (database, storage, cache)"
    echo "4. 🔧 Service Module (utilities, helpers, services)"
    echo "5. 🎨 Widget Module (reusable custom widgets)"
    echo ""

    # Module type selection
    while true; do
        read -p "Choose module type (1-5): " MODULE_TYPE
        case $MODULE_TYPE in
            1) MODULE_TEMPLATE="ui"; break ;;
            2) MODULE_TEMPLATE="networking"; break ;;
            3) MODULE_TEMPLATE="data"; break ;;
            4) MODULE_TEMPLATE="service"; break ;;
            5) MODULE_TEMPLATE="widget"; break ;;
            *) print_error "Invalid choice. Please enter 1-5." ;;
        esac
    done

    # Get module name
    while true; do
        read -p "Enter the module name (e.g., user_profile, api_client): " MODULE_NAME
        if [[ -z "$MODULE_NAME" ]]; then
            print_error "Module name cannot be empty!"
            continue
        fi
        
        # Validate module name
        if [[ ! "$MODULE_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
            print_error "Module name must be lowercase, start with a letter, and contain only letters, numbers, and underscores!"
            continue
        fi
        
        break
    done

    # Create module directory structure
    MODULE_DIR="lib/app/modules/$MODULE_NAME"
    
    if [[ -d "$MODULE_DIR" ]]; then
        read -p "Module '$MODULE_NAME' already exists. Overwrite? (y/N): " OVERWRITE
        if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
            print_error "Operation cancelled."
            exit 1
        fi
        rm -rf "$MODULE_DIR"
    fi

    print_status "Creating module '$MODULE_NAME' of type '$MODULE_TEMPLATE'..."
    mkdir -p "$MODULE_DIR"

    # Generate module files based on type
    case $MODULE_TEMPLATE in
        "ui")
            create_ui_module "$MODULE_DIR" "$MODULE_NAME" "$PROJECT_NAME"
            ;;
        "networking")
            create_networking_module "$MODULE_DIR" "$MODULE_NAME" "$PROJECT_NAME"
            ;;
        "data")
            create_data_module "$MODULE_DIR" "$MODULE_NAME" "$PROJECT_NAME"
            ;;
        "service")
            create_service_module "$MODULE_DIR" "$MODULE_NAME" "$PROJECT_NAME"
            ;;
        "widget")
            create_widget_module "$MODULE_DIR" "$MODULE_NAME" "$PROJECT_NAME"
            ;;
    esac

    print_success "🎉 Module '$MODULE_NAME' created successfully!"
    echo ""
    print_status "Module location: $MODULE_DIR"
    echo ""
    print_status "Next steps:"
    echo "  1. Review generated files in $MODULE_DIR"
    echo "  2. Add routes to app_pages.dart if needed"
    echo "  3. Register bindings in app_bindings.dart if needed"
    echo "  4. Start implementing your module logic! 🚀"
}

# Function to create UI module
create_ui_module() {
    local MODULE_DIR=$1
    local MODULE_NAME=$2
    local PROJECT_NAME=$3
    
    # Convert snake_case to PascalCase for class names
    CLASS_NAME=$(echo "$MODULE_NAME" | awk -F'_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' OFS='')
    
    mkdir -p "$MODULE_DIR/controllers"
    mkdir -p "$MODULE_DIR/views"
    mkdir -p "$MODULE_DIR/bindings"

    # Create controller
    cat > "$MODULE_DIR/controllers/${MODULE_NAME}_controller.dart" << EOF
import 'package:get/get.dart';

class ${CLASS_NAME}Controller extends GetxController {
  // Reactive variables
  final RxString title = '${CLASS_NAME} Module'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('${CLASS_NAME}Controller initialized');
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  @override
  void onClose() {
    print('${CLASS_NAME}Controller disposed');
    super.onClose();
  }

  // Methods
  void loadData() async {
    try {
      isLoading.value = true;
      // TODO: Implement data loading logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
      print('Data loaded for ${CLASS_NAME}');
    } catch (e) {
      print('Error loading data: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  void onRefresh() {
    loadData();
  }
}
EOF

    # Create view
    cat > "$MODULE_DIR/views/${MODULE_NAME}_view.dart" << EOF
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/${MODULE_NAME}_controller.dart';

class ${CLASS_NAME}View extends GetView<${CLASS_NAME}Controller> {
  const ${CLASS_NAME}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async => controller.onRefresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.widgets,
                          size: 64,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome to ${CLASS_NAME} Module',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This is a generated UI module. Start customizing!',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.onRefresh,
                  child: const Text('Refresh Data'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
EOF

    # Create binding
    cat > "$MODULE_DIR/bindings/${MODULE_NAME}_binding.dart" << EOF
import 'package:get/get.dart';
import '../controllers/${MODULE_NAME}_controller.dart';

class ${CLASS_NAME}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${CLASS_NAME}Controller>(
      () => ${CLASS_NAME}Controller(),
    );
  }
}
EOF

    print_status "✅ Created UI module files:"
    print_status "   - Controller: $MODULE_DIR/controllers/${MODULE_NAME}_controller.dart"
    print_status "   - View: $MODULE_DIR/views/${MODULE_NAME}_view.dart"
    print_status "   - Binding: $MODULE_DIR/bindings/${MODULE_NAME}_binding.dart"
}

# Function to create networking module
create_networking_module() {
    local MODULE_DIR=$1
    local MODULE_NAME=$2
    local PROJECT_NAME=$3
    
    CLASS_NAME=$(echo "$MODULE_NAME" | sed 's/_\([a-z]\)/\U\1/g' | sed 's/^./\U&/')
    
    mkdir -p "$MODULE_DIR/models"
    mkdir -p "$MODULE_DIR/services"
    mkdir -p "$MODULE_DIR/repositories"

    # Create model
    cat > "$MODULE_DIR/models/${MODULE_NAME}_model.dart" << EOF
class ${CLASS_NAME}Model {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ${CLASS_NAME}Model({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory ${CLASS_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${CLASS_NAME}Model(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy with
  ${CLASS_NAME}Model copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ${CLASS_NAME}Model(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '${CLASS_NAME}Model(id: \$id, name: \$name, description: \$description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ${CLASS_NAME}Model && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
EOF

    # Create service
    cat > "$MODULE_DIR/services/${MODULE_NAME}_service.dart" << EOF
import 'package:get/get.dart';
import '../models/${MODULE_NAME}_model.dart';

class ${CLASS_NAME}Service extends GetxService {
  // Base URL - consider moving to environment config
  final String baseUrl = 'https://api.example.com';
  
  // GetConnect for HTTP requests
  final GetConnect _connect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    _configureConnect();
  }

  void _configureConnect() {
    _connect.baseUrl = baseUrl;
    _connect.timeout = const Duration(seconds: 30);
    
    // Add interceptors
    _connect.httpClient.addRequestModifier<dynamic>((request) {
      // Add authorization headers, etc.
      request.headers['Content-Type'] = 'application/json';
      return request;
    });

    _connect.httpClient.addResponseModifier((request, response) {
      // Handle global response processing
      return response;
    });
  }

  // Get all items
  Future<List<${CLASS_NAME}Model>> getAll() async {
    try {
      final response = await _connect.get('/${MODULE_NAME}');
      
      if (response.hasError) {
        throw Exception('Failed to fetch ${MODULE_NAME}: \${response.statusText}');
      }

      final List<dynamic> data = response.body['data'] ?? [];
      return data.map((json) => ${CLASS_NAME}Model.fromJson(json)).toList();
    } catch (e) {
      print('Error in ${CLASS_NAME}Service.getAll(): \$e');
      rethrow;
    }
  }

  // Get by ID
  Future<${CLASS_NAME}Model?> getById(String id) async {
    try {
      final response = await _connect.get('/${MODULE_NAME}/\$id');
      
      if (response.hasError) {
        throw Exception('Failed to fetch ${MODULE_NAME} \$id: \${response.statusText}');
      }

      return ${CLASS_NAME}Model.fromJson(response.body['data']);
    } catch (e) {
      print('Error in ${CLASS_NAME}Service.getById(): \$e');
      return null;
    }
  }

  // Create
  Future<${CLASS_NAME}Model?> create(${CLASS_NAME}Model item) async {
    try {
      final response = await _connect.post('/${MODULE_NAME}', item.toJson());
      
      if (response.hasError) {
        throw Exception('Failed to create ${MODULE_NAME}: \${response.statusText}');
      }

      return ${CLASS_NAME}Model.fromJson(response.body['data']);
    } catch (e) {
      print('Error in ${CLASS_NAME}Service.create(): \$e');
      return null;
    }
  }

  // Update
  Future<${CLASS_NAME}Model?> update(String id, ${CLASS_NAME}Model item) async {
    try {
      final response = await _connect.put('/${MODULE_NAME}/\$id', item.toJson());
      
      if (response.hasError) {
        throw Exception('Failed to update ${MODULE_NAME} \$id: \${response.statusText}');
      }

      return ${CLASS_NAME}Model.fromJson(response.body['data']);
    } catch (e) {
      print('Error in ${CLASS_NAME}Service.update(): \$e');
      return null;
    }
  }

  // Delete
  Future<bool> delete(String id) async {
    try {
      final response = await _connect.delete('/${MODULE_NAME}/\$id');
      
      if (response.hasError) {
        throw Exception('Failed to delete ${MODULE_NAME} \$id: \${response.statusText}');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('Error in ${CLASS_NAME}Service.delete(): \$e');
      return false;
    }
  }
}
EOF

    # Create repository
    cat > "$MODULE_DIR/repositories/${MODULE_NAME}_repository.dart" << EOF
import 'package:get/get.dart';
import '../models/${MODULE_NAME}_model.dart';
import '../services/${MODULE_NAME}_service.dart';

class ${CLASS_NAME}Repository {
  final ${CLASS_NAME}Service _service = Get.find<${CLASS_NAME}Service>();

  // Cache for local storage
  final RxList<${CLASS_NAME}Model> _cache = <${CLASS_NAME}Model>[].obs;
  List<${CLASS_NAME}Model> get cache => _cache.toList();

  // Get all with caching
  Future<List<${CLASS_NAME}Model>> getAll({bool forceRefresh = false}) async {
    if (_cache.isEmpty || forceRefresh) {
      try {
        final items = await _service.getAll();
        _cache.assignAll(items);
      } catch (e) {
        print('Repository error in getAll(): \$e');
        if (_cache.isEmpty) rethrow;
      }
    }
    return _cache.toList();
  }

  // Get by ID
  Future<${CLASS_NAME}Model?> getById(String id) async {
    // Check cache first
    final cached = _cache.firstWhereOrNull((item) => item.id == id);
    if (cached != null) return cached;

    // Fetch from service
    try {
      final item = await _service.getById(id);
      if (item != null) {
        _addToCache(item);
      }
      return item;
    } catch (e) {
      print('Repository error in getById(): \$e');
      return null;
    }
  }

  // Create
  Future<${CLASS_NAME}Model?> create(${CLASS_NAME}Model item) async {
    try {
      final created = await _service.create(item);
      if (created != null) {
        _addToCache(created);
      }
      return created;
    } catch (e) {
      print('Repository error in create(): \$e');
      return null;
    }
  }

  // Update
  Future<${CLASS_NAME}Model?> update(String id, ${CLASS_NAME}Model item) async {
    try {
      final updated = await _service.update(id, item);
      if (updated != null) {
        _updateInCache(updated);
      }
      return updated;
    } catch (e) {
      print('Repository error in update(): \$e');
      return null;
    }
  }

  // Delete
  Future<bool> delete(String id) async {
    try {
      final success = await _service.delete(id);
      if (success) {
        _removeFromCache(id);
      }
      return success;
    } catch (e) {
      print('Repository error in delete(): \$e');
      return false;
    }
  }

  // Cache management
  void _addToCache(${CLASS_NAME}Model item) {
    final index = _cache.indexWhere((cached) => cached.id == item.id);
    if (index != -1) {
      _cache[index] = item;
    } else {
      _cache.add(item);
    }
  }

  void _updateInCache(${CLASS_NAME}Model item) {
    final index = _cache.indexWhere((cached) => cached.id == item.id);
    if (index != -1) {
      _cache[index] = item;
    }
  }

  void _removeFromCache(String id) {
    _cache.removeWhere((item) => item.id == id);
  }

  void clearCache() {
    _cache.clear();
  }
}
EOF

    print_status "✅ Created networking module files:"
    print_status "   - Model: $MODULE_DIR/models/${MODULE_NAME}_model.dart"
    print_status "   - Service: $MODULE_DIR/services/${MODULE_NAME}_service.dart"
    print_status "   - Repository: $MODULE_DIR/repositories/${MODULE_NAME}_repository.dart"
}

# Function to create data module
create_data_module() {
    local MODULE_DIR=$1
    local MODULE_NAME=$2
    local PROJECT_NAME=$3
    
    CLASS_NAME=$(echo "$MODULE_NAME" | sed 's/_\([a-z]\)/\U\1/g' | sed 's/^./\U&/')
    
    mkdir -p "$MODULE_DIR/storage"
    mkdir -p "$MODULE_DIR/cache"

    # Create storage service
    cat > "$MODULE_DIR/storage/${MODULE_NAME}_storage.dart" << EOF
import 'package:get_storage/get_storage.dart';

class ${CLASS_NAME}Storage {
  static const String _boxName = '${MODULE_NAME}_storage';
  late final GetStorage _box;

  // Initialize storage
  Future<void> init() async {
    await GetStorage.init(_boxName);
    _box = GetStorage(_boxName);
  }

  // Generic read/write methods
  T? read<T>(String key) => _box.read<T>(key);
  
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clear() async {
    await _box.erase();
  }

  bool hasData(String key) => _box.hasData(key);

  // Specific methods for this module
  List<Map<String, dynamic>> get${CLASS_NAME}List() {
    final data = read<List>('${MODULE_NAME}_list');
    return data?.cast<Map<String, dynamic>>() ?? [];
  }

  Future<void> save${CLASS_NAME}List(List<Map<String, dynamic>> list) async {
    await write('${MODULE_NAME}_list', list);
  }

  Map<String, dynamic>? get${CLASS_NAME}ById(String id) {
    final list = get${CLASS_NAME}List();
    try {
      return list.firstWhere((item) => item['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> save${CLASS_NAME}(Map<String, dynamic> item) async {
    final list = get${CLASS_NAME}List();
    final index = list.indexWhere((existing) => existing['id'] == item['id']);
    
    if (index != -1) {
      list[index] = item;
    } else {
      list.add(item);
    }
    
    await save${CLASS_NAME}List(list);
  }

  Future<void> delete${CLASS_NAME}(String id) async {
    final list = get${CLASS_NAME}List();
    list.removeWhere((item) => item['id'] == id);
    await save${CLASS_NAME}List(list);
  }

  // Settings and preferences
  String? getSettings(String key) => read<String>('settings_\$key');
  
  Future<void> saveSettings(String key, String value) async {
    await write('settings_\$key', value);
  }

  // Last sync timestamp
  DateTime? getLastSyncTime() {
    final timestamp = read<String>('last_sync');
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  Future<void> updateLastSyncTime() async {
    await write('last_sync', DateTime.now().toIso8601String());
  }
}
EOF

    # Create cache manager
    cat > "$MODULE_DIR/cache/${MODULE_NAME}_cache.dart" << EOF
import 'dart:convert';

class ${CLASS_NAME}Cache {
  static final Map<String, _CacheItem> _cache = {};
  static const Duration defaultTTL = Duration(hours: 1);

  // Store data with TTL
  static void store<T>(String key, T data, {Duration? ttl}) {
    final expiry = DateTime.now().add(ttl ?? defaultTTL);
    _cache[key] = _CacheItem(data, expiry);
  }

  // Retrieve data
  static T? get<T>(String key) {
    final item = _cache[key];
    if (item == null) return null;

    if (item.isExpired) {
      _cache.remove(key);
      return null;
    }

    return item.data as T?;
  }

  // Check if key exists and is valid
  static bool has(String key) {
    final item = _cache[key];
    if (item == null) return false;

    if (item.isExpired) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  // Remove specific key
  static void remove(String key) {
    _cache.remove(key);
  }

  // Clear all cache
  static void clear() {
    _cache.clear();
  }

  // Clear expired items
  static void clearExpired() {
    final now = DateTime.now();
    _cache.removeWhere((key, item) => item.expiry.isBefore(now));
  }

  // Get cache statistics
  static Map<String, dynamic> getStats() {
    clearExpired(); // Clean up first
    return {
      'total_items': _cache.length,
      'memory_usage_kb': _getMemoryUsage(),
      'oldest_item': _getOldestItemAge(),
    };
  }

  // Estimate memory usage (rough calculation)
  static double _getMemoryUsage() {
    int totalBytes = 0;
    for (final item in _cache.values) {
      try {
        final encoded = jsonEncode(item.data);
        totalBytes += encoded.length;
      } catch (e) {
        // Skip items that can't be encoded
        totalBytes += 100; // Rough estimate
      }
    }
    return totalBytes / 1024; // Convert to KB
  }

  // Get age of oldest item
  static Duration? _getOldestItemAge() {
    if (_cache.isEmpty) return null;
    
    DateTime? oldest;
    for (final item in _cache.values) {
      if (oldest == null || item.expiry.isBefore(oldest)) {
        oldest = item.expiry;
      }
    }
    
    return oldest != null ? DateTime.now().difference(oldest) : null;
  }

  // ${CLASS_NAME} specific cache methods
  static const String _listKey = '${MODULE_NAME}_list';
  static const String _detailKeyPrefix = '${MODULE_NAME}_detail_';

  static void store${CLASS_NAME}List(List<Map<String, dynamic>> list) {
    store(_listKey, list, ttl: const Duration(minutes: 30));
  }

  static List<Map<String, dynamic>>? get${CLASS_NAME}List() {
    final data = get<List>(_listKey);
    return data?.cast<Map<String, dynamic>>();
  }

  static void store${CLASS_NAME}Detail(String id, Map<String, dynamic> detail) {
    store('\$_detailKeyPrefix\$id', detail, ttl: const Duration(hours: 2));
  }

  static Map<String, dynamic>? get${CLASS_NAME}Detail(String id) {
    return get<Map<String, dynamic>>('\$_detailKeyPrefix\$id');
  }

  static void remove${CLASS_NAME}Detail(String id) {
    remove('\$_detailKeyPrefix\$id');
  }
}

class _CacheItem {
  final dynamic data;
  final DateTime expiry;

  _CacheItem(this.data, this.expiry);

  bool get isExpired => DateTime.now().isAfter(expiry);
}
EOF

    print_status "✅ Created data module files:"
    print_status "   - Storage: $MODULE_DIR/storage/${MODULE_NAME}_storage.dart"
    print_status "   - Cache: $MODULE_DIR/cache/${MODULE_NAME}_cache.dart"
}

# Function to create service module
create_service_module() {
    local MODULE_DIR=$1
    local MODULE_NAME=$2
    local PROJECT_NAME=$3
    
    CLASS_NAME=$(echo "$MODULE_NAME" | sed 's/_\([a-z]\)/\U\1/g' | sed 's/^./\U&/')
    
    mkdir -p "$MODULE_DIR/helpers"
    mkdir -p "$MODULE_DIR/utils"

    # Create service
    cat > "$MODULE_DIR/${MODULE_NAME}_service.dart" << EOF
import 'package:get/get.dart';

class ${CLASS_NAME}Service extends GetxService {
  @override
  void onInit() {
    super.onInit();
    print('${CLASS_NAME}Service initialized');
  }

  @override
  void onClose() {
    print('${CLASS_NAME}Service disposed');
    super.onClose();
  }

  // Example service methods
  Future<String> processData(String input) async {
    try {
      // Simulate processing
      await Future.delayed(const Duration(milliseconds: 500));
      return 'Processed: \$input';
    } catch (e) {
      print('Error in ${CLASS_NAME}Service.processData(): \$e');
      rethrow;
    }
  }

  Future<bool> validateInput(String input) async {
    // Example validation logic
    return input.isNotEmpty && input.length >= 3;
  }

  Future<Map<String, dynamic>> getStatus() async {
    return {
      'service': '${CLASS_NAME}Service',
      'status': 'active',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
EOF

    # Create helper
    cat > "$MODULE_DIR/helpers/${MODULE_NAME}_helper.dart" << EOF
class ${CLASS_NAME}Helper {
  // Static utility methods for ${MODULE_NAME}
  
  static String formatText(String input) {
    if (input.isEmpty) return '';
    return input.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }

  static bool isValidFormat(String input) {
    if (input.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9_]+\$').hasMatch(input);
  }

  static String capitalize(String input) {
    if (input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  static List<String> splitAndClean(String input, {String separator = ','}) {
    return input
        .split(separator)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static String joinWithSeparator(List<String> items, {String separator = ', '}) {
    return items.where((item) => item.isNotEmpty).join(separator);
  }

  static Map<String, dynamic> sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};
    
    for (final entry in data.entries) {
      final key = entry.key.trim();
      if (key.isNotEmpty) {
        final value = entry.value;
        if (value is String) {
          sanitized[key] = value.trim();
        } else {
          sanitized[key] = value;
        }
      }
    }
    
    return sanitized;
  }

  static String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return '${MODULE_NAME}_\${timestamp}_\$random';
  }

  static bool compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.parse).toList();
    final v2Parts = version2.split('.').map(int.parse).toList();
    
    final maxLength = v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;
    
    for (int i = 0; i < maxLength; i++) {
      final v1Part = i < v1Parts.length ? v1Parts[i] : 0;
      final v2Part = i < v2Parts.length ? v2Parts[i] : 0;
      
      if (v1Part < v2Part) return true;
      if (v1Part > v2Part) return false;
    }
    
    return false; // versions are equal
  }
}
EOF

    # Create utils
    cat > "$MODULE_DIR/utils/${MODULE_NAME}_utils.dart" << EOF
import 'dart:convert';
import 'dart:math';

class ${CLASS_NAME}Utils {
  // Logging utilities
  static void logInfo(String message) {
    print('[${CLASS_NAME}] INFO: \$message');
  }

  static void logError(String message, [dynamic error]) {
    print('[${CLASS_NAME}] ERROR: \$message');
    if (error != null) {
      print('[${CLASS_NAME}] ERROR DETAILS: \$error');
    }
  }

  static void logWarning(String message) {
    print('[${CLASS_NAME}] WARNING: \$message');
  }

  // JSON utilities
  static String toJsonString(dynamic object) {
    try {
      return jsonEncode(object);
    } catch (e) {
      logError('Failed to encode JSON', e);
      return '{}';
    }
  }

  static T? fromJsonString<T>(String jsonString, T Function(Map<String, dynamic>) fromJson) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return fromJson(json);
    } catch (e) {
      logError('Failed to decode JSON', e);
      return null;
    }
  }

  // String utilities
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  static String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  static String escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  // Number utilities
  static String formatNumber(num number, {int decimals = 2}) {
    return number.toStringAsFixed(decimals);
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '\$bytes B';
    if (bytes < 1024 * 1024) return '\${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '\${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '\${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Date utilities
  static String formatDate(DateTime date) {
    return '\${date.year}-\${date.month.toString().padLeft(2, '0')}-\${date.day.toString().padLeft(2, '0')}';
  }

  static String formatTime(DateTime time) {
    return '\${time.hour.toString().padLeft(2, '0')}:\${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '\${formatDate(dateTime)} \${formatTime(dateTime)}';
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '\${difference.inDays} day\${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '\${difference.inHours} hour\${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '\${difference.inMinutes} minute\${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Random utilities
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  static int generateRandomNumber(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  // Validation utilities
  static bool isEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$').hasMatch(email);
  }

  static bool isUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  static bool isPhoneNumber(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}\$').hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
}
EOF

    print_status "✅ Created service module files:"
    print_status "   - Service: $MODULE_DIR/${MODULE_NAME}_service.dart"
    print_status "   - Helper: $MODULE_DIR/helpers/${MODULE_NAME}_helper.dart"
    print_status "   - Utils: $MODULE_DIR/utils/${MODULE_NAME}_utils.dart"
}

# Function to create widget module
create_widget_module() {
    local MODULE_DIR=$1
    local MODULE_NAME=$2
    local PROJECT_NAME=$3
    
    CLASS_NAME=$(echo "$MODULE_NAME" | sed 's/_\([a-z]\)/\U\1/g' | sed 's/^./\U&/')
    
    mkdir -p "$MODULE_DIR/widgets"

    # Create main widget
    cat > "$MODULE_DIR/widgets/${MODULE_NAME}_widget.dart" << EOF
import 'package:flutter/material.dart';

class ${CLASS_NAME}Widget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ${CLASS_NAME}Widget({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).cardColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
EOF

    # Create button widget
    cat > "$MODULE_DIR/widgets/${MODULE_NAME}_button.dart" << EOF
import 'package:flutter/material.dart';

enum ${CLASS_NAME}ButtonType { primary, secondary, outlined, text }

class ${CLASS_NAME}Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ${CLASS_NAME}ButtonType type;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const ${CLASS_NAME}Button({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ${CLASS_NAME}ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (type) {
      case ${CLASS_NAME}ButtonType.primary:
        button = _buildElevatedButton(context);
        break;
      case ${CLASS_NAME}ButtonType.secondary:
        button = _buildFilledButton(context);
        break;
      case ${CLASS_NAME}ButtonType.outlined:
        button = _buildOutlinedButton(context);
        break;
      case ${CLASS_NAME}ButtonType.text:
        button = _buildTextButton(context);
        break;
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: _buildButtonChild(),
    );
  }

  Widget _buildFilledButton(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: _buildButtonChild(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: _buildButtonChild(),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: _buildButtonChild(),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
EOF

    # Create input widget
    cat > "$MODULE_DIR/widgets/${MODULE_NAME}_input.dart" << EOF
import 'package:flutter/material.dart';

class ${CLASS_NAME}Input extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;

  const ${CLASS_NAME}Input({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: contentPadding ?? 
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled 
              ? Theme.of(context).cardColor 
              : Theme.of(context).disabledColor.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
EOF

    print_status "✅ Created widget module files:"
    print_status "   - Widget: $MODULE_DIR/widgets/${MODULE_NAME}_widget.dart"
    print_status "   - Button: $MODULE_DIR/widgets/${MODULE_NAME}_button.dart"
    print_status "   - Input: $MODULE_DIR/widgets/${MODULE_NAME}_input.dart"
}

# Main execution
case $CHOICE in
    1)
        create_new_project
        ;;
    2)
        add_new_module
        ;;
esac

echo ""
print_success "🚀 Operation completed successfully!"
print_status "Happy coding! 🎯"