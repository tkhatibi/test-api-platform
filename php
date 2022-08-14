#!/bin/bash

export NO_LOG=1

$(cd $(dirname "$0") && pwd)/app dcx php php ${@:1}
