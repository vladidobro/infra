#!/usr/bin/env python3
import os
import sys
import csv
import random
import string
import qrcode
import secrets
import qrcode.image.svg


def generate_code(length=8):
    characters = "abcdefghijkmnpqrstuvwxyz23456789"
    return ''.join(secrets.choice(characters) for _ in range(length))

def main():
    # Check if folder parameter is provided
    if len(sys.argv) < 3:
        print("Usage: python generate_codes.py <folder> <subfolder>")
        sys.exit(1)
    
    base_folder = sys.argv[1]
    sub_folder = sys.argv[2]
    factory = qrcode.image.svg.SvgPathImage
    if not os.path.isdir(base_folder):
        print(f"The provided folder '{base_folder}' does not exist.")
        sys.exit(1)
    
    # Create subfolder inside the provided folder
    subfolder_name = sub_folder
    subfolder_path = os.path.join(base_folder, subfolder_name)
    os.makedirs(subfolder_path, exist_ok=True)
    
    # Define how many codes to generate
    num_codes = 100  # Change this value as needed

    # CSV file setup: it will contain the code, URL, and image file name
    csv_filename = "codes.csv"
    csv_filepath = os.path.join(subfolder_path, csv_filename)
    
    with open(csv_filepath, mode='w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(["Code", "URL", "QR_Image"])
        
        for _ in range(num_codes):
            code = generate_code(8)
            url = f"https://svatba.maskova.wohlrath.cz/?code={code}"
            
            # Generate QR code for the URL
            qr = qrcode.QRCode(
                version=1,
                error_correction=qrcode.constants.ERROR_CORRECT_L,
                box_size=10,
                border=4,
            )
            qr.add_data(url)
            qr.make(fit=True)
            img = qr.make_image(fill_color="black", back_color="white", image_factory=factory)

            # save svg img to file
            qr_filename = f"{code}.svg"
            qr_filepath = os.path.join(subfolder_path, qr_filename)
            img.save(qr_filepath)
            
            # Write the details to CSV
            csv_writer.writerow([code, url, qr_filename])
    
    print(f"Generated {num_codes} codes. CSV and QR images are saved in '{subfolder_path}'.")

if __name__ == '__main__':
    main()