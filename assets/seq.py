import time
import os
import re
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# --- Configuration ---
WATCH_DIRECTORY = os.getcwd()  # Watch the current working directory
TARGET_EXTENSION = ".png"
SCREENSHOT_PREFIX = "Screenshot"
# Regex to match sequential files like "1.png", "10.png", "100.png"
SEQUENCE_PATTERN = re.compile(r'^\d+\.png$', re.IGNORECASE)

class ScreenshotHandler(FileSystemEventHandler):
    """
    Handles file system events (like file creation) and renames screenshots.
    """

    def _get_next_sequence_number(self):
        """
        Calculates the next available sequence number by checking existing files.
        """
        current_max = 0
        
        # Iterate over all files in the watched directory
        for filename in os.listdir(WATCH_DIRECTORY):
            # Check if the filename matches the sequential pattern (e.g., "1.png")
            if SEQUENCE_PATTERN.match(filename):
                try:
                    # Extract the number part from the filename
                    # Example: "12.png" -> "12"
                    number_part = filename.split('.')[0]
                    file_number = int(number_part)
                    
                    if file_number > current_max:
                        current_max = file_number
                        
                except ValueError:
                    # Skip files that might match the pattern but contain non-numeric characters 
                    # before the extension (shouldn't happen with the strict regex)
                    continue

        return current_max + 1

    def on_created(self, event):
        """
        Called when a file or directory is created.
        """
        if event.is_directory:
            return
            
        src_path = event.src_path
        filename = os.path.basename(src_path)

        # 1. Check if the file is a PNG and starts with the Screenshot prefix
        if filename.lower().endswith(TARGET_EXTENSION) and filename.startswith(SCREENSHOT_PREFIX):
            
            print(f"\n[DETECTED] New screenshot: {filename}")
            time.sleep(2)  
            # 2. Determine the next sequence number
            next_number = self._get_next_sequence_number()
            
            # 3. Construct the new filename
            new_filename = f"{next_number}{TARGET_EXTENSION}"
            dest_path = os.path.join(WATCH_DIRECTORY, new_filename)
            
            try:
                # 4. Rename the file
                os.rename(src_path, dest_path)
                print(f"[RENAMED] '{filename}' -> '{new_filename}'")
            except OSError as e:
                print(f"[ERROR] Could not rename file: {e}")
        
        # 5. Optionally, clean up temporary files created by screenshot utilities 
        #    (e.g., macOS might create files like .<filename>.ext.sb-03487f8f)
        elif not filename.startswith(SCREENSHOT_PREFIX) and not SEQUENCE_PATTERN.match(filename):
            print(f"[INFO] New file created: {filename} (Ignored)")


if __name__ == "__main__":
    print(f"--- 📸 Screenshot Sequencer Started ---")
    print(f"Watching directory: {WATCH_DIRECTORY}")
    print("Press Ctrl+C to stop.")
    
    # Initialize the event handler and observer
    event_handler = ScreenshotHandler()
    observer = Observer()
    
    # Start monitoring the directory recursively
    observer.schedule(event_handler, WATCH_DIRECTORY, recursive=False)
    observer.start()

    try:
        # Keep the main thread alive, watching for events
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    
    # Wait until all threads are finished
    observer.join()
    
    print("\n--- Sequencer Stopped ---")
