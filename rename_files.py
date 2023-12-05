import os
import hashlib

def calculate_md5(file_path):
    md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        chunk = f.read(8192)
        while chunk:
            md5.update(chunk)
            chunk = f.read(8192)
    return md5.hexdigest()

def rename_files(root_folder):
    for foldername, subfolders, filenames in os.walk(root_folder):
        for filename in filenames:
            file_path = os.path.join(foldername, filename)
            md5 = calculate_md5(file_path)
            
            # Construct the new filename
            base_name, extension = os.path.splitext(filename)
            new_filename = "{}_{}{}".format(base_name, md5, extension)

            # Rename the file
            os.rename(file_path, os.path.join(foldername, new_filename))

if __name__ == "__main__":
    user_input = input("Enter the folder path (press ENTER to use the current path): ").strip()
    print(user_input)
    if user_input == "":
        root_folder = os.getcwd()
    else:
        root_folder = user_input
    rename_files(root_folder)
    print("Done")
