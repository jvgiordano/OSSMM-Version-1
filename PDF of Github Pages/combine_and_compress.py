# Written with the aid of Claude 4 Opus (June 2nd, 2025)

import os
import subprocess
from PyPDF2 import PdfMerger
import time

class PDFProcessor:
    """
    A comprehensive PDF processor that handles both merging and compression.
    
    This class combines multiple PDF files into one and then applies
    Ghostscript compression to reduce the file size while maintaining quality.
    """
    
    def __init__(self, gs_path=None):
        """
        Initialize the PDF processor.
        
        gs_path: Path to Ghostscript executable. If None, tries common locations.
        """
        # Try to find Ghostscript automatically if no path provided
        if gs_path is None:
            possible_paths = [
                r"C:\Program Files\gs\gs10.05.1\bin\gswin64c.exe",
                r"C:\Program Files\gs\gs10.02.0\bin\gswin64c.exe",
            ]
            
            for path in possible_paths:
                if os.path.exists(path):
                    self.gs_path = path
                    print(f"Found Ghostscript at: {path}")
                    break
            else:
                self.gs_path = None
                print("Warning: Ghostscript not found. Compression will be skipped.")
                print("Install from: https://www.ghostscript.com/download/gsdnld.html")
        else:
            self.gs_path = gs_path
    
    def merge_pdfs(self, pdf_files, output_file="merged_temp.pdf"):
        """
        Merge multiple PDF files into a single PDF.
        
        This method takes a list of PDF filenames and combines them in order.
        It returns the path to the merged file and the total size.
        """
        print("="*60)
        print("STEP 1: MERGING PDFs")
        print("="*60)
        
        merger = PdfMerger()
        files_merged = 0
        
        # Process each PDF file
        for pdf_file in pdf_files:
            if os.path.exists(pdf_file):
                try:
                    file_size = os.path.getsize(pdf_file) / 1024 / 1024  # Size in MB
                    print(f"Adding: {pdf_file} ({file_size:.1f} MB)")
                    merger.append(pdf_file)
                    files_merged += 1
                except Exception as e:
                    print(f"Error adding {pdf_file}: {e}")
            else:
                print(f"Warning: {pdf_file} not found, skipping...")
        
        if files_merged == 0:
            print("No files were successfully added!")
            return None
        
        # Write the merged PDF
        print(f"\nWriting merged PDF...")
        merger.write(output_file)
        merger.close()
        
        # Report merge results
        merged_size = os.path.getsize(output_file) / 1024 / 1024
        print(f"\n✓ Merged {files_merged} files into: {output_file}")
        print(f"✓ Merged file size: {merged_size:.1f} MB")
        
        return output_file
    
    def compress_pdf(self, input_file, output_file, quality='printer'):
        """
        Compress a PDF using Ghostscript with various quality presets.
        
        Quality presets explained:
        - 'screen': Lowest quality, smallest file (72 dpi) - for screen viewing only
        - 'ebook': Medium quality (150 dpi) - good for tablets/computers
        - 'printer': High quality (300 dpi) - suitable for printing
        - 'prepress': Maximum quality (300 dpi, color preserving) - minimal compression
        
        For a thesis, 'printer' is typically the best choice.
        """
        print("\n" + "="*60)
        print("STEP 2: COMPRESSING PDF")
        print("="*60)
        
        if self.gs_path is None:
            print("Skipping compression - Ghostscript not installed")
            return False
        
        # Get original size
        original_size = os.path.getsize(input_file) / 1024 / 1024
        print(f"Original size: {original_size:.1f} MB")
        print(f"Compression quality: {quality}")
        print("Processing... (this may take a few minutes for large files)")
        
        # Build the Ghostscript command
        command = [
            self.gs_path,
            '-sDEVICE=pdfwrite',              # Output as PDF
            '-dCompatibilityLevel=1.4',       # Widely compatible PDF version
            f'-dPDFSETTINGS=/{quality}',      # Quality preset
            '-dNOPAUSE',                      # Don't pause between pages
            '-dQUIET',                        # Minimal output
            '-dBATCH',                        # Exit when done
            '-dCompressFonts=true',           # Compress embedded fonts
            '-dSubsetFonts=true',             # Only include used characters
            '-dColorImageDownsampleType=/Bicubic',  # High-quality downsampling
            '-dGrayImageDownsampleType=/Bicubic',
            '-dMonoImageDownsampleType=/Bicubic',
            '-dDetectDuplicateImages=true',   # Remove duplicate images
            '-dFastWebView=true',             # Optimize for web viewing
            f'-sOutputFile={output_file}',    # Output file
            input_file                        # Input file
        ]
        
        # Run compression
        start_time = time.time()
        try:
            subprocess.run(command, check=True, capture_output=True)
            
            # Calculate results
            compressed_size = os.path.getsize(output_file) / 1024 / 1024
            compression_time = time.time() - start_time
            reduction_percent = (1 - compressed_size / original_size) * 100
            
            print(f"\n✓ Compression complete in {compression_time:.1f} seconds")
            print(f"✓ Compressed size: {compressed_size:.1f} MB")
            print(f"✓ Size reduction: {reduction_percent:.1f}%")
            print(f"✓ Saved: {original_size - compressed_size:.1f} MB")
            
            return True
            
        except subprocess.CalledProcessError as e:
            print(f"\n✗ Compression failed: {e}")
            return False
        except Exception as e:
            print(f"\n✗ Unexpected error: {e}")
            return False
    
    def process_pdfs(self, pdf_files, final_output="OSSMM_Complete_Documentation.pdf", 
                     quality='printer', keep_merged=False):
        """
        The main method that orchestrates the entire process.
        
        This combines merging and compression into one smooth workflow:
        1. Merges all PDFs into a temporary file
        2. Compresses the merged file
        3. Cleans up temporary files (unless keep_merged=True)
        
        Parameters:
        - pdf_files: List of PDF filenames to merge
        - final_output: Name for the final compressed PDF
        - quality: Compression quality setting
        - keep_merged: Whether to keep the uncompressed merged file
        """
        print("\nPDF PROCESSOR - MERGE AND COMPRESS")
        print("==================================\n")
        
        # Step 1: Merge PDFs
        temp_merged = "temp_merged.pdf"
        merged_file = self.merge_pdfs(pdf_files, temp_merged)
        
        if merged_file is None:
            print("\nProcess failed: No files to merge")
            return
        
        # Step 2: Compress the merged PDF
        if self.gs_path:
            compression_success = self.compress_pdf(merged_file, final_output, quality)
            
            if compression_success:
                # Clean up temporary file unless requested to keep it
                if not keep_merged:
                    os.remove(temp_merged)
                    print(f"\nCleaned up temporary file: {temp_merged}")
                else:
                    print(f"\nKept uncompressed file: {temp_merged}")
                
                print(f"\n✓ FINAL OUTPUT: {final_output}")
            else:
                print(f"\nCompression failed. Uncompressed file available at: {temp_merged}")
        else:
            # If no Ghostscript, just rename the merged file
            os.rename(temp_merged, final_output)
            print(f"\nNo compression applied. Output saved as: {final_output}")
        
        print("\nProcess complete!")


# HOW TO USE THE SCRIPT
# ====================

# Define your PDF files in the order you want them
pdf_files = [
    'Home.pdf',
    'Quick_Introduction.pdf',
    'Getting_Started.pdf',
    '3D_Printables.pdf',
    'Electronics_Assembly.pdf',
    'Major_Parts_Assembly.pdf',
    'Software.pdf',
    'Final_Checks.pdf',
    'Safety_and_Data.pdf',
    'Performance.pdf',
    'Demo.pdf'
]

# Create the processor
processor = PDFProcessor()

# Process everything with default settings (printer quality)
processor.process_pdfs(pdf_files)

# Or, if you want different quality settings:
# processor.process_pdfs(pdf_files, quality='ebook')  # Smaller file, medium quality

# Or, if you want to keep the uncompressed merged file too:
# processor.process_pdfs(pdf_files, keep_merged=True)

# Or, if you want a custom output filename:
# processor.process_pdfs(pdf_files, final_output="OSSMM_Thesis_Appendix.pdf")