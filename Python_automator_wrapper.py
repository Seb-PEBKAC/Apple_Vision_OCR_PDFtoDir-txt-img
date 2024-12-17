import os
import subprocess
import argparse

def run_automator_app(pdf_path, app_path):
    """
    Run an Automator application with a PDF file as input.
    
    Args:
        pdf_path (str): Path to the input PDF file.
        app_path (str): Path to the Automator application (.app).

    Examples:
        Basic usage with default app:
        >>> python3 Python_automator_wrapper.py ./Assets/screencapture-en-wikipedia-org-wiki-English-language.pdf

        Using a custom Automator app:
        >>> python3 Python_automator_wrapper.py ./Assets/screencapture-en-wikipedia-org-wiki-English-language.pdf --app /path/to/custom.app

    Flags:
        --app: Optional path to a custom Automator application. 
              Defaults to ./PDFtoDir-txt-img.app
    """
    if not os.path.isfile(pdf_path):
        raise FileNotFoundError(f"PDF file not found: {pdf_path}")
    
    if not os.path.exists(app_path):
        raise FileNotFoundError(f"Automator application not found: {app_path}")
    
    # Use 'open' command to run the Automator app with the PDF file as input
    try:
        subprocess.run(['open', '-a', app_path, pdf_path], check=True)
        print("Automator application executed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
        raise RuntimeError("Failed to execute Automator application.")

def main():
    # Get the absolute path of the script's directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    default_app = os.path.join(script_dir, "PDFtoDir-txt-img.app")

    parser = argparse.ArgumentParser(description="Run an Automator application to render PDF pages as images.")
    parser.add_argument("pdf_path", type=str, help="Path to the input PDF file.", nargs='?')
    parser.add_argument("--app", 
                       type=str, 
                       default=default_app,
                       help="Path to the Automator application (.app). Defaults to PDFtoDir-txt-img.app in the script directory")
    args = parser.parse_args()

    # If PDF path not provided, prompt for it
    pdf_path = args.pdf_path or input("Enter the path to the PDF file: ")
    app_path = args.app

    try:
        run_automator_app(pdf_path, app_path)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()