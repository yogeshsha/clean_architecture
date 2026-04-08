#!/bin/bash

# ─────────────────────────────────────────────
# Flutter Clean Architecture Feature Generator
# Usage: bash create_feature.sh <feature_name>
# Example: bash create_feature.sh articles
# ─────────────────────────────────────────────

set -e

if [ -z "$1" ]; then
  echo "Error: Please provide a feature name."
  echo "Usage: bash create_feature.sh <feature_name>"
  exit 1
fi

FEATURE_RAW="$1"

# Convert to snake_case (lowercase, spaces/hyphens → underscore)
FEATURE=$(echo "$FEATURE_RAW" | tr '[:upper:]' '[:lower:]' | tr ' -' '_')

# ── Name helpers ──────────────────────────────
# PascalCase: e.g. user_profile → UserProfile
to_pascal() {
  echo "$1" | awk -F'_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); OFS=""; print}'
}

PASCAL=$(to_pascal "$FEATURE")          # e.g. UserProfile
PASCAL_PLURAL="${PASCAL}"              # e.g. UserProfiles  (used for screen/list provider)

PACKAGE="test_project"
BASE="lib/feature/${FEATURE}"

echo ""
echo "Creating feature: $PASCAL"
echo "Path: $BASE"
echo "──────────────────────────────────────────"

# ── Create directory tree ─────────────────────
mkdir -p "$BASE/domain/entity"
mkdir -p "$BASE/domain/repositories"
mkdir -p "$BASE/domain/usecases"
mkdir -p "$BASE/data/model"
mkdir -p "$BASE/data/data_source"
mkdir -p "$BASE/data/repositories"
mkdir -p "$BASE/presentation/provider"
mkdir -p "$BASE/presentation/screen"
mkdir -p "$BASE/presentation/widgets"

# ─────────────────────────────────────────────
# 1. domain/entity
# ─────────────────────────────────────────────
cat > "$BASE/domain/entity/${FEATURE}_entity.dart" <<DART
import 'package:equatable/equatable.dart';

class ${PASCAL}Entity extends Equatable {
  final int id;
  final String title;
  final String body;

  const ${PASCAL}Entity({
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [id, title, body];
}
DART

# ─────────────────────────────────────────────
# 2. domain/repositories (abstract)
# ─────────────────────────────────────────────
cat > "$BASE/domain/repositories/${FEATURE}_repositories.dart" <<DART
import 'package:${PACKAGE}/feature/${FEATURE}/domain/entity/${FEATURE}_entity.dart';

abstract class ${PASCAL}Repositories {
  Future<List<${PASCAL}Entity>> get${PASCAL_PLURAL}();
}
DART

# ─────────────────────────────────────────────
# 3. domain/usecases
# ─────────────────────────────────────────────
cat > "$BASE/domain/usecases/${FEATURE}_usecases.dart" <<DART
import '../entity/${FEATURE}_entity.dart';
import '../repositories/${FEATURE}_repositories.dart';

class ${PASCAL}UseCases {
  final ${PASCAL}Repositories ${FEATURE}Repositories;

  ${PASCAL}UseCases({required this.${FEATURE}Repositories});

  Future<List<${PASCAL}Entity>> call() async {
    return await ${FEATURE}Repositories.get${PASCAL_PLURAL}();
  }
}
DART

# ─────────────────────────────────────────────
# 4. data/model
# ─────────────────────────────────────────────
cat > "$BASE/data/model/${FEATURE}_model.dart" <<DART
import '../../domain/entity/${FEATURE}_entity.dart';

class ${PASCAL}Model extends ${PASCAL}Entity {
  const ${PASCAL}Model({
    required super.id,
    required super.title,
    required super.body,
  });

  factory ${PASCAL}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL}Model(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  ${PASCAL}Entity toEntity() => ${PASCAL}Entity(id: id, title: title, body: body);
}
DART

# ─────────────────────────────────────────────
# 5. data/data_source
# ─────────────────────────────────────────────
cat > "$BASE/data/data_source/remote_data_source.dart" <<DART
import 'dart:convert';

import 'package:${PACKAGE}/feature/${FEATURE}/data/model/${FEATURE}_model.dart';
import 'package:http/http.dart' as http;

abstract class ${PASCAL}DataSource {
  Future<List<${PASCAL}Model>> get${PASCAL}();
}

class ${PASCAL}DataSourceImpl extends ${PASCAL}DataSource {
  @override
  Future<List<${PASCAL}Model>> get${PASCAL}() async {
    const url = 'https://jsonplaceholder.typicode.com/posts'; // TODO: replace with actual endpoint

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<dynamic>;
      return json.map((e) => ${PASCAL}Model.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load ${FEATURE}');
    }
  }
}
DART

# ─────────────────────────────────────────────
# 6. data/repositories (impl)
# ─────────────────────────────────────────────
cat > "$BASE/data/repositories/${FEATURE}_repositories_impl.dart" <<DART
import 'package:${PACKAGE}/feature/${FEATURE}/domain/entity/${FEATURE}_entity.dart';
import 'package:${PACKAGE}/feature/${FEATURE}/domain/repositories/${FEATURE}_repositories.dart';

import '../data_source/remote_data_source.dart';

class ${PASCAL}RepositoriesImpl extends ${PASCAL}Repositories {
  final ${PASCAL}DataSource ${FEATURE}DataSource;

  ${PASCAL}RepositoriesImpl({required this.${FEATURE}DataSource});

  @override
  Future<List<${PASCAL}Entity>> get${PASCAL_PLURAL}() async {
    final value = await ${FEATURE}DataSource.get${PASCAL}();
    return value.map((e) => e.toEntity()).toList();
  }
}
DART

# ─────────────────────────────────────────────
# 7. presentation/provider
# ─────────────────────────────────────────────
cat > "$BASE/presentation/provider/${FEATURE}_provider.dart" <<DART
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_source/remote_data_source.dart';
import '../../data/repositories/${FEATURE}_repositories_impl.dart';
import '../../domain/repositories/${FEATURE}_repositories.dart';
import '../../domain/usecases/${FEATURE}_usecases.dart';

final ${FEATURE}RemoteDataSourceProvider = Provider<${PASCAL}DataSource>((ref) {
  return ${PASCAL}DataSourceImpl();
});

final ${FEATURE}RepositoryProvider = Provider<${PASCAL}Repositories>((ref) {
  return ${PASCAL}RepositoriesImpl(
    ${FEATURE}DataSource: ref.watch(${FEATURE}RemoteDataSourceProvider),
  );
});

final get${PASCAL_PLURAL}UseCaseProvider = Provider((ref) {
  return ${PASCAL}UseCases(
    ${FEATURE}Repositories: ref.watch(${FEATURE}RepositoryProvider),
  );
});

final ${FEATURE}Provider = FutureProvider((ref) async {
  final useCase = ref.watch(get${PASCAL_PLURAL}UseCaseProvider);
  return await useCase();
});
DART

# ─────────────────────────────────────────────
# 8. presentation/screen
# ─────────────────────────────────────────────
cat > "$BASE/presentation/screen/${FEATURE}_screen.dart" <<DART
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:${PACKAGE}/feature/${FEATURE}/presentation/provider/${FEATURE}_provider.dart';
import 'package:${PACKAGE}/feature/${FEATURE}/presentation/widgets/${FEATURE}_card.dart';

class ${PASCAL}Screen extends ConsumerWidget {
  const ${PASCAL}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(${FEATURE}Provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('${PASCAL_PLURAL}'),
      ),
      body: asyncData.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ${PASCAL}Card(item: items[index]);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: \$e')),
      ),
    );
  }
}
DART

# ─────────────────────────────────────────────
# 9. presentation/widgets – card
# ─────────────────────────────────────────────
cat > "$BASE/presentation/widgets/${FEATURE}_card.dart" <<DART
import 'package:flutter/material.dart';
import '../../domain/entity/${FEATURE}_entity.dart';

class ${PASCAL}Card extends StatelessWidget {
  final ${PASCAL}Entity item;

  const ${PASCAL}Card({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item.body),
          ],
        ),
      ),
    );
  }
}
DART

# ─────────────────────────────────────────────
echo ""
echo "✅  Feature '$PASCAL' created successfully!"
echo ""
echo "Files generated:"
find "$BASE" -type f | sort
echo ""
echo "Next steps:"
echo "  1. Update the API endpoint in: $BASE/data/data_source/remote_data_source.dart"
echo "  2. Add fields to:              $BASE/domain/entity/${FEATURE}_entity.dart"
echo "  3. Register the screen route in your app router."
echo ""