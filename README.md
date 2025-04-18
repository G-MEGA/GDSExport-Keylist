# GDSExport-Keylist

## How to use

If you have an resource that contain a property, Dictionary or Array, as Database...

![image](https://github.com/user-attachments/assets/b89b89eb-5b1d-46a7-b0f0-0dfcf4549ab7)
![image](https://github.com/user-attachments/assets/c1a9603b-0067-4048-9b16-2fabb73f40dc)

You can use `@export_custom` on PackedStringArray variable with following arguments

- `PROPERTY_HINT_MAX`
- `KeyList:{{Path of the resource}}/{{Name of the property}}`

![image](https://github.com/user-attachments/assets/c65f7fb3-f439-4735-8f6a-e23ec4d2d1ef)

so... PackedStringArray will be limited to have keys of the property and be restricted from having duplicate key values.

![This is KeyList](https://github.com/user-attachments/assets/bf36eb15-f137-4cd5-960e-22883605b829)
