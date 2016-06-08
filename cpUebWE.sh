#!/bin/bash
rsync -a ~/Workspace/ueb0* ~/temp/ &&
rm -rf ~/temp/ueb0*/.git &&
rsync -a ~/temp/ueb0* ~/Workspace/gitHubFiles/ &&
rm -rf ~/temp/ueb0*
