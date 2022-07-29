What is this?

This is a pared-down fork of the bats project intended to be run on the sewanee.dev shiny server. Rather than generating the data-bats.RData file that drives the dashboard, this fork loads in a pre-generated one.

IF YOU LOSE THE DATA FILE:
You need to generate a new one using the main branch of bats, namely the DataClean-bats.Rmd script. Follow Hallie's instructions for file paths; the script was written with a specific file convention in mind. THIS FORK CANNOT GENERATE THE DATA FILE. Once you've generated it, use your sftp client of choice to copy the data file to the server's /Data/Bats directory.