# Git Upload Instructions for FurnitureHub

## Your GitHub Repository
**Repository URL:** https://github.com/Ronak-coder/QRONDINE.git

---

## Method 1: Using GitHub Desktop (EASIEST)

1. **Download GitHub Desktop**
   - Visit: https://desktop.github.com/
   - Install and sign in with your GitHub account

2. **Add Your Project**
   - Open GitHub Desktop
   - Click "File" → "Add Local Repository"
   - Browse to: `d:\Ronak_Nyariya\flutter_ecommerce_customer`
   - Click "Add Repository"

3. **If "Repository Not Found" appears:**
   - Click "Create a repository"
   - Name: `flutter_ecommerce_customer` or `FurnitureHub`
   - Make sure path is: `d:\Ronak_Nyariya\flutter_ecommerce_customer`
   - Click "Create Repository"

4. **Commit Your Changes**
   - You'll see all your files listed
   - In the "Summary" field, type: `Complete FurnitureHub app with all features`
   - In the "Description" field, add:
     ```
     - Furniture e-commerce app with ratings system
     - Authentication-gated checkout
     - Best product badges for top-rated items
     - Local asset image support
     - Responsive UI for all devices
     - Complete shopping cart and checkout flow
     ```
   - Click "Commit to main"

5. **Publish to GitHub**
   - Click "Publish repository" button
   - **IMPORTANT:** Change repository name to `QRONDINE` (to match your existing repo)
   - Or use "Repository" → "Repository settings" → "Remote" → Add remote
   - Remote name: `origin`
   - URL: `https://github.com/Ronak-coder/QRONDINE.git`
   - Click "Push origin"

---

## Method 2: Using Git Command Line (If you install Git)

After installing Git from https://git-scm.com/download/win:

```powershell
# Navigate to project
cd d:\Ronak_Nyariya\flutter_ecommerce_customer

# Initialize git repository
git init

# Add all files
git add .

# Commit changes
git commit -m "Complete FurnitureHub app with ratings, auth, and responsive UI"

# Add your GitHub repository as remote
git remote add origin https://github.com/Ronak-coder/QRONDINE.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

## Method 3: Manual Upload via GitHub Website

1. Go to: https://github.com/Ronak-coder/QRONDINE
2. Click "Add file" → "Upload files"
3. Drag and drop entire project folder
4. Add commit message: "Complete FurnitureHub app"
5. Click "Commit changes"

⚠️ **Note:** This method is slower for large projects

---

## What Will Be Uploaded

All your FurnitureHub code including:
- ✅ Complete Flutter app source code
- ✅ Product rating system
- ✅ Authentication flow
- ✅ Shopping cart & checkout
- ✅ Local furniture images
- ✅ All dependencies (pubspec.yaml)
- ✅ Android build files

---

## Recommended: Create .gitignore

Before uploading, add this `.gitignore` file to exclude build files:

```
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/

# Android
*.jks
android/.gradle/
android/app/build/
android/local.properties

# iOS
ios/.generated/
ios/Flutter/flutter_export_environment.sh
ios/Pods/

# IDE
.idea/
.vscode/
*.swp
*.swo

# APK files (optional - remove if you want to upload APK)
*.apk
*.aab
```

Save this as `.gitignore` in your project root before committing.

---

## Need Help?

Choose the method that works best for you:
- **Easiest:** GitHub Desktop (Method 1)
- **Most Control:** Git Command Line (Method 2)
- **No Installation:** Web Upload (Method 3)

After uploading, your code will be available at:
https://github.com/Ronak-coder/QRONDINE
