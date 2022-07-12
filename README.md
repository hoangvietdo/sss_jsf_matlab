## Side Scan Sonar .jsf Reader written in Matlab

Matlab code for extracting data message from a given ```.jsf``` file (side scan sonar from EdgeTech).

The parsing code is made based on the format descriptions from EdgeTech ```edge_tech_jsf_rev_2022.pdf``` (version June 17, 2022).

## Info
Currently, only message type 80 (sonar data) and type 3000 (currently testing and checking) are extracted and decoded.

## Usage
1. Run ```cookJsfDataset.m``` with the correct ```path``` and ```file``` variable and choose the message type to be recorded by setting the variable ```type80```, ```type3000``` or ```type3002``` to be ```1```.

    - Note that message ```type3000``` and ```type3002``` should be set at the same time. (these types are not currently recommended since it is too large).
2. Run ```checkDataset.m``` to plot the acoustic measurement.

## Q&A
Contact ```hoangvietdo@sju.ac.kr``` or make an issue for discussion.
