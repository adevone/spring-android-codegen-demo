# Coding conventions
## Field is always required if:
- For a `string` type
  - Not an url or a deep link
  - Empty string means the same as null string
- For an `array` type
  - Empty array means the same as null array
  
## Enums
- Each enum should have an default value for backward compatibility purposes