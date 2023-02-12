#!/bin/bash -e

FILENAMES=(
  "scripts/do_release.sh"
  ".github/workflows/release.yml"
  ".goreleaser.yml"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
fail() {
  printf "${RED}$1${NC}\n" 1>&2
  exit 1
}

cd $(dirname $0)/..

for FILENAME in ${FILENAMES[@]};do
  test -f $FILENAME || fail "$FILENAME file missing from base repo! `find`"

  #Locate and destroy!
  for target in `ls ../*/$FILENAME | grep -v golang_cicdactions_example`;do
    SRC=$FILENAME

    #Allow yaml files to have overrides spliced in with spruce
    if [[ $target == *.yml && -f "$target.overrides" ]]; then
      spruce merge "$FILENAME" "$target.overrides" > /tmp/merged.yml
      SRC=/tmp/merged.yml
    fi

    if ! cmp -s "$SRC" "$target";then
      BASE_DIR=$(echo $target | cut -d "/" -f 2)
      printf "${GREEN}Replacing $target in $BASE_DIR${NC}\n"

      cp "$SRC" "$target"
      cd "../$BASE_DIR"
      if ! git ls-files --error-unmatch $FILENAME >/dev/null 2>&1;then
        printf "${GREEN}  Adding to git...${NC}"
        git add $FILENAME >/dev/null
      fi
      git commit -m 'Update pipeline' $FILENAME && git push
      cd - >/dev/null
    fi
  done #End loop through targets
done #End loop through filnames
