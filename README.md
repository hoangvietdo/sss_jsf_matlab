## Side Scan Sonar .jsf Reader written in Matlab

Matlab code for extracting data message from a given ```.jsf``` file (side scan sonar from EdgeTech).

The parsing code is made based on the format descriptions from EdgeTech ```edge_tech_jsf_rev_2022.pdf``` (version June 17, 2022).

## Info
Currently, only message type 80 (sonar data) is extracted and decoded. Other messages will be cracked in the future.

## Usage
1. Run ```cookJsfDataset.m``` with the correct ```path``` and ```file``` variable.
2. Run ```checkDataset.m``` to plot the acoustic measurement.

## Q&A
Contact ```hoangvietdo@sju.ac.kr``` or make an issue for discussion.
