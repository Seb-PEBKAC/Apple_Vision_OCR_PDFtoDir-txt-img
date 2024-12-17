# PDF to Directory (Images & Text) Extractor

This tool leverages Apple's Vision framework through an Automator workflow to extract both images and text from PDF files. The package includes both a Finder application for drag-and-drop functionality and a Python wrapper for programmatic usage. This application is native to macOS and does not require any additional dependencies. Making it suitable for users who don't want to send their PDF files to a cloud service. (The Apple Vision framework has some quirks. This is a work in progress.)

Multimodal embedding models exist, but they are not native to macOS (yet). PDFs with complex images and diagrams Require both image and text data too be vectorized in a useful manner. This simple tool gets you one step closer to that goal.

If you like this tool, please consider giving the Repo a star, it helps me get more visibility and more people to use it. it took me a couple days to work through the quirks of the Apple frameworks.

## Features

- Extract images from PDF pages
- Extract text content using Apple Vision OCR
- Multiple usage options:
  - Command-line interface
  - Python API
  - Drag-and-drop GUI

## Prerequisites
- macOS (Apple Silicon)
- Python 3.8+
- Apple Vision framework (built into macOS)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/Apple_Vision_OCR_PDFtoDir-txt-img.git
cd Apple_Vision_OCR_PDFtoDir-txt-img
```

## Usage

### 1. Command Line Interface

Use the Python wrapper script directly from the command line:

```bash
python3 Python_automator_wrapper.py ./Assets/screencapture-en-wikipedia-org-wiki-English-language.pdf
```

Optional: Specify a custom Automator app path: (you can build your own from workflow and developer tools)
```bash
python3 Python_automator_wrapper.py ./Assets/example.pdf --app /path/to/custom.app
```

### 2. Python API

Import and use the function in your Python code:

```python
from Python_automator_wrapper import run_automator_app

# Process a PDF file
pdf_path = "./Assets/example.pdf"
app_path = "./PDFtoDir-txt-img.app"  # Default app path

try:
    run_automator_app(pdf_path, app_path)
    print("PDF processing completed successfully")
except Exception as e:
    print(f"Error processing PDF: {e}")
```

### 3. Drag and Drop (GUI)

1. Locate the `PDFtoDir-txt-img.app` in Finder
2. Drag and drop any PDF file onto the application icon
3. The app will automatically process the PDF and create a directory containing:
   - Image files for each page
   - Extracted text content

## Output Structure

For an input file `example.pdf`, the tool creates:
```
example_output/
├── page_1.png
├── page_2.png
└── ...
├── page_1.txt
├── page_2.txt
└── ...
```

## Technical Details

### Automator Script Implementation
The `Automator-OCR-Images.applescript` is the core component that handles the OCR processing:

- Uses Apple's Vision framework for text recognition
- Processes a list of images passed through the `Storage` variable
- `Storage` variable structure:
  ```
  Storage = [
      image_alias_1,    # First image file alias
      image_alias_2,    # Second image file alias
      ...,
      output_dir_path   # Last item is the output directory path
  ]
  ```
- For each image, the script:
  1. Performs OCR using VNRecognizeTextRequest
  2. Extracts text with accurate recognition level
  3. Saves the extracted text to a .txt file in the output directory
  4. Maintains the same base filename for both image and text files

## Known Issues

### Non-English PDF Documents
When processing PDFs in languages such as German, French, and Spanish:
- Image extraction does not work correctly for all pages
- OCR text extraction only outputs the text from the last page in the set
- Setting specific language parameters for the OCR system has not resolved this limitation
- This is a known limitation requiring further development for reliable multi-language support



## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 