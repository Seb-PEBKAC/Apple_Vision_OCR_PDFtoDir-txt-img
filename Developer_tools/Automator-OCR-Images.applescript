use AppleScript version "2.4"
use framework "Foundation"
use framework "Vision"
use scripting additions

on run {Storage}
    set itemCount to count of Storage
    if itemCount < 2 then
        -- Return error message as text, no dialog
        return "Not enough items in Storage: Need at least one image and one output directory."
    end if
    
    set outputFolder to item itemCount of Storage
    set imageFiles to items 1 thru (itemCount - 1) of Storage
    
    -- Initialize the VNRecognizeTextRequest
    set visionTextRequest to current application's VNRecognizeTextRequest's new()
    visionTextRequest's setRecognitionLevel:(current application's VNRequestTextRecognitionLevelAccurate)
    
    -- Ensure output directory exists
    do shell script "mkdir -p " & quoted form of outputFolder
    
    repeat with imageAlias in imageFiles
        set filePath to POSIX path of imageAlias
        set fileInfo to info for imageAlias
        set fileName to name of fileInfo
        
        -- Extract base name without extension
        set dotPos to offset of "." in fileName
        if dotPos > 0 then
            set baseName to text 1 thru (dotPos - 1) of fileName
        else
            set baseName to fileName
        end if
        
        -- Perform OCR on the image
        set ocrText to extractTextFromImage(filePath, visionTextRequest)
        
        -- Save OCR result as a .txt file
        set outputPath to (outputFolder & "/" & baseName & ".txt") as text
        do shell script "echo " & quoted form of ocrText & " > " & quoted form of outputPath
    end repeat
    
    -- Return a success message quietly
    return "OCR process complete! Text files saved to: " & outputFolder
end run

on extractTextFromImage(filePath, visionRequest)
    set inputURL to current application's NSURL's fileURLWithPath:filePath
    set inputImage to current application's VNImageRequestHandler's alloc()'s initWithURL:inputURL options:(missing value)
    
    set theError to reference
    set success to (inputImage's performRequests:{visionRequest} |error|:theError)
    if success is false then
        if theError ≠ missing value then
            set errMsg to theError's localizedDescription() as text
            log "Error during OCR: " & errMsg
        else
            log "Unknown error during OCR."
        end if
        return ""
    end if
    
    set ocrResult to ""
    set observations to visionRequest's results()
    repeat with observation in observations
        set candidates to observation's topCandidates:1
        if (candidates's |count|()) > 0 then
            set candidate to candidates's objectAtIndex:0
            set recognizedNSString to candidate's |string|
            set recognizedText to recognizedNSString as text
            set ocrResult to ocrResult & recognizedText & linefeed
        else
            log "No text candidates found for this image."
        end if
    end repeat
    
    return ocrResult
end extractTextFromImage
