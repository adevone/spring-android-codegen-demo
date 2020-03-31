# Правила написания
## Поле всегда required если оно:
- Для типа string
  - Не является url или deepLink
  - Пустая строка по смыслу не отличается от отсутствия строки
- Для типа array
  - Пустой массив по смыслу ничем не отличается от отсутствия массива
  
## Enums
- Каждый enum, который где-то объявлен как required, должен имет значение по-умолчанию

# Git
## pre-commit hook
```
#!/bin/sh
MINOR_VERSION=$(cat minor_version.txt)
MINOR_VERSION=$((MINOR_VERSION+1))
echo $MINOR_VERSION > minor_version.txt
git add minor_version.txt
```