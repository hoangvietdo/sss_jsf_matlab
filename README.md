## Side Scan Sonar .jsf Reader written in Matlab

Matlab code for extracting data message from a given ```.jsf``` file (side scan sonar from EdgeTech).

The parsing code is made based on the format descriptions from EdgeTech ```edge_tech_jsf_rev_2022.pdf``` (version June 17, 2022).

## Info
Currently, only message type 80 (sonar data) and type (3000 + 3002) (still testing and checking) are extracted and decoded.

## Usage
1. Run ```cookJsfDataset.m``` with the correct ```path``` and ```file``` variable and choose to record the family message type 3000 by setting the variable ```type3000 = 1```. Default value is ```1```.
    - Note that type 80 is the base of decoding, the family message type 300x is optional.
    - Decoding and saving type 300x might consume a long time and the saved ```.mat``` file is big (> 6 GB).
    - If type 300x is not needed, simply comment out the parsing code for 300x (2 ```elseif``` loops).
    
2. Run ```checkDataset.m``` to plot the acoustic measurement.

## Q&A
Contact ```hoangvietdo@sju.ac.kr``` or make an issue for discussion.

PRs are of course welcome.
