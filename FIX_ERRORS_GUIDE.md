# Step-by-Step Guide to Fix Errors Before Running

## Problem Identified
The Flutter/Dart SDK is locked by another process (likely your IDE or editor), preventing Flutter from updating or accessing the Dart SDK files. This causes errors when trying to run the application.

## Solution Steps

### Step 1: Close All IDEs and Editors
1. **Close Android Studio** (if open)
   - Go to File → Exit or click the X button
   - Make sure all Android Studio windows are closed

2. **Close VS Code** (if open)
   - Press `Ctrl+Q` or go to File → Exit
   - Check the system tray for any VS Code processes

3. **Close IntelliJ IDEA** (if open)
   - Go to File → Exit

4. **Close Cursor** (if applicable)
   - Make sure all instances are closed

### Step 2: Check Running Processes
1. Press `Ctrl+Shift+Esc` to open Task Manager
2. Look for these processes and end them if running:
   - `dart.exe`
   - `java.exe` (related to Android Studio)
   - `Studio64.exe` (Android Studio)
   - `code.exe` (VS Code)
   - Any other IDE processes

### Step 3: Release File Locks (Optional - Advanced)
If files are still locked after closing IDEs:
1. Open PowerShell as Administrator
2. Run this command to find what's locking the Dart SDK:
   ```powershell
   Get-Process | Where-Object {$_.Path -like "*flutter*" -or $_.Path -like "*dart*"}
   ```
3. If any processes are found, note their names and close them manually

### Step 4: Verify Flutter Installation
1. Open a **new** PowerShell or Command Prompt window
2. Run:
   ```bash
   flutter doctor
   ```
3. If you still see the same error, proceed to Step 5

### Step 5: Clean Flutter Cache (If Needed)
If the error persists:
1. In PowerShell/Command Prompt, run:
   ```bash
   flutter clean
   ```
2. Wait for the command to complete
3. Then run:
   ```bash
   flutter pub get
   ```

### Step 6: Get Project Dependencies
1. Navigate to your project directory:
   ```bash
   cd "C:\Users\Selvin Crisostomo\Documents\elective3project"
   ```
2. Get Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Wait for all packages to download

### Step 7: Verify Project Setup
1. Check if dependencies are properly installed:
   ```bash
   flutter pub get
   ```
   - Should complete without errors
   
2. Verify your Dart SDK version compatibility:
   - Open `pubspec.yaml`
   - The current SDK version `^3.11.0-49.0.dev` is a dev channel version
   - If you encounter compatibility issues, you may need to change it to a stable version like `^3.0.0` or `^3.1.0`

### Step 8: Check Platform-Specific Setup

#### For Android Development:
1. Verify Android SDK is installed:
   ```bash
   flutter doctor -v
   ```
2. Look for Android toolchain status
3. If missing, install Android Studio and Android SDK

#### For Windows Development:
1. Ensure you have Visual Studio installed with:
   - Desktop development with C++ workload
   - Windows 10/11 SDK

### Step 9: Final Verification
1. Run Flutter doctor again:
   ```bash
   flutter doctor
   ```
2. You should see checkmarks (✓) for:
   - Flutter (the Flutter SDK)
   - Android toolchain (if developing for Android)
   - VS Code or Android Studio (your IDE)
   
3. Any warnings (!) are usually okay, but errors (✗) need to be fixed

### Step 10: Run the Application
Once all errors are resolved:
1. Make sure no IDE is open that might lock files
2. Run your Flutter app:
   ```bash
   flutter run
   ```
   Or for a specific device:
   ```bash
   flutter run -d windows    # For Windows
   flutter run -d chrome     # For Web
   ```

## Common Issues and Quick Fixes

### Issue: "Unable to update Dart SDK"
**Solution**: Close all IDEs and editors, wait 10 seconds, then try again.

### Issue: "No devices found"
**Solution**: 
- For Android: Start an emulator or connect a physical device
- For Windows: Ensure you're running on Windows
- For Web: Run `flutter run -d chrome`

### Issue: "Pub get failed"
**Solution**:
- Check your internet connection
- Try `flutter pub cache repair`
- Then `flutter pub get` again

### Issue: "SDK version mismatch"
**Solution**:
- Update Flutter: `flutter upgrade`
- Or adjust the SDK version in `pubspec.yaml` to match your Flutter version

## Prevention Tips
1. **Always close IDEs before running Flutter commands** from the terminal
2. **Use one IDE at a time** - don't have multiple IDEs open simultaneously
3. **Wait a few seconds** after closing IDEs before running Flutter commands
4. **Use terminal/command line** for Flutter commands instead of IDE buttons when encountering file lock issues

## Quick Checklist
Before running your app, ensure:
- [ ] All IDEs and editors are closed
- [ ] No Dart/Flutter processes are running in Task Manager
- [ ] `flutter doctor` runs without errors
- [ ] `flutter pub get` completes successfully
- [ ] You have a target device/emulator available
- [ ] You're in the correct project directory

---

**Note**: If you continue to experience issues after following these steps, the problem might be:
- Corrupted Flutter installation (reinstall Flutter)
- Antivirus blocking file access (add Flutter folder to exclusions)
- Permission issues (run PowerShell/Command Prompt as Administrator)

