#!/opt/homebrew/bin/bash

#------------------------------------------------------------------------------
#     Workflow Menu
#------------------------------------------------------------------------------

cmm_main ()
(
   trap cmm_exit EXIT

   # explain why here
   set -euo pipefail

   # explain why here
   IFS=$'\n\t'

   # escape codes for text colorization
   red=$(tput setaf 1)
   green=$(tput setaf 2)
   yellow=$(tput setaf 3)
   blue=$(tput setaf 4)
   reset=$(tput sgr0)

   returncode=0
   msg="wip"
   JEKYLL_ENV=development

   cd $CMM_SOURCE
   cmm_precheck
   cmm_menu
)

cmm_options () 
{
   for i in "${!OPTS[@]}"; do
      printf "%d) %s\n" $(($i+1)) "${OPTS[$i]}"
   done
}
   
# POSIX menu

cmm_menu() 
{
   OPTS=(exit status edit build serve publish)

   cmm_options

   while printf "cmm > "; read -r REPLY
   do
   case $REPLY in
   
      "")
         cmm_options
         ;;
      1)
         cmm_exit
         ;;
      2)
         cmm_status
         ;;
      3)
         cmm_edit
         ;;
      4)
         cmm_build
         ;;
      5)
         cmm_serve
         ;;
      6)
         cmm_publish
         ;;
     *)
         eval "$REPLY"; returncode=$?
         # log-recent -r $? -c "$(HISTTIMEFORMAT= history 1)" -p $$
         ;;

   esac
   done
}

# Bash menu

cmm_select ()
{
   PS3="> "

   set -o posix

   select option in exit status edit build serve publish
   do
      [[ -n $option ]] || { eval "$REPLY"; continue; }
      $(printf "cmm_%s\n" $option); returncode=$?
      if [ $returncode -eq 0 ]; then continue; fi
   done
   set +o posix
}

#------------------------------------------------------------------------------
#     Menu options
#------------------------------------------------------------------------------

cmm_exit()     { exit; }
cmm_edit()     { bbedit $CMM_SOURCE; }
cmm_serve()    { open http://localhost:4000/; }

cmm_status()   
{ 
   git lg -1; 
   git status --short; 
}

cmm_build()
{
   SECONDS=0;

   pushd $CMM_SOURCE/_data

   # update data directory
   # cmm_sync --exclude=*.numbers $CMM_DATA/ .
   
   # convert line endings from DOS to UNIX
   gsed -i 's/\r$//' *.tsv
   
   # update derived data
   sqlite3 < repertoire.sql   # needed for archive
   sqlite3 < worksheet.sql    # needed for reservation checklist

   popd
   
   jekyll build --quiet --trace

   cmm_print "build completed in $SECONDS seconds"
}

cmm_publish() 
(
   cd $CMM_SOURCE
   cmm_precheck

   cmm_print "SOURCE"
  
   # reset HEAD while preserving changes to working tree
   # any commits on current branch will become orphans
   git reset --soft $defaultBranch

   # commit changes on feature branch
   msg="wip"; cmm_commit

   git switch --quiet $defaultBranch
   git merge --quiet $featureBranch
   git pull --quiet origin $defaultBranch
   git push --quiet origin $defaultBranch
   git switch --quiet --force-create $featureBranch

   cmm_print "SITE"

   # commit changes and publish website
   pushd $CMM_SITE
   cmm_commit
   git push --quiet origin core
   popd
)

cmm_stage() 
(
   cd $CMM_SOURCE

   cmm_print "SOURCE"
  
   # reset HEAD while preserving changes to working tree
   # any commits on current branch will become orphans
   git reset --soft $stagingBranch

   # commit changes on feature branch
   msg="wip"; cmm_commit

   git switch --quiet $stagingBranch
   git merge --quiet $featureBranch
   git switch --quiet --force-create $featureBranch
)

#------------------------------------------------------------------------------
#    Workflow Utilities
#------------------------------------------------------------------------------

cmm_docs()  { open https://jekyllrb.com/docs/; }
cmm_sync()  { rsync --recursive --archive --times --update $@; }

cmm_precheck () 
{
   git rev-parse --is-inside-work-tree > /dev/null 2>&1; returncode=$?
   if [ $returncode -ne 0 ]
   then
      cmm_error "fatal error (probably not a git repo)"
      cmm_exit
   fi

   defaultBranch=$(git config --get init.defaultBranch)
   featureBranch=$(git branch --show-current)
   stagingBranch="next"
   
   # make sure we're not on main branch or staging branch
   if [[ $featureBranch == $defaultBranch ]]
   then
      cmm_error "please switch to a feature branch"
      cmm_exit
   fi
}

cmm_print () 
{ 
   printf "%s" $yellow;
   printf '==> %s\n' "$1";
   printf "%s" $reset
}

cmm_error () 
{ 
   printf "%s" $red;
   printf '==> %s\n' "$1";
   printf "%s" $reset
   cmm_exit
}

cmm_commit () 
{
   status=$(git status --short;)
   if [[ -n "$status" ]]; then
      # echo "$status"
      read -ep "Commit message [$msg]: " input
      msg="${input:-$msg}"
      git add -A
      git commit --quiet -m "$msg"
   fi
}

#------------------------------------------------------------------------------
#     Other Utilities
#------------------------------------------------------------------------------

# cmm_concerts()
# {
#    for f in $(git ls-files 'collections/_concerts');
#    do 
#       git --no-pager log -1 --pretty=format:'%aI' -- $f ; echo "	$f";
#    done
# }

cmm_once()
{
   pushd $CMM_SOURCE/_data

   sqlite3 <<EOS

.headers on
.mode tabs
.import concerts.tsv concert
.import programs.tsv program

UPDATE
    program
SET
    date = c.date
FROM 
   (SELECT concert, date FROM concert) AS c
   WHERE program.date = c.concert
;

.once programs.tsv

SELECT * FROM program;

EOS

   popd
}

cmm_dedup() {
  pushd $HOME
  cp .recent.db .recent_backup.db
  
  sqlite3 .recent.db <<EOS

BEGIN;
CREATE TABLE temp as
SELECT * FROM commands WHERE 1 GROUP BY command;
DROP INDEX command_dt_ind;
DROP TABLE commands;
ALTER TABLE temp RENAME TO commands;
CREATE INDEX command_dt_ind on commands (command_dt);
END;

VACUUM;

EOS
  popd
}

# subtract 3 seconds for correct fade-out
cmm_fade () 
{
   pushd "/Users/Core/Movies/YouTube"
   ffmpeg -i video.mp4 -filter_complex \
   "fade=in:st=0:d=2, fade=out:st=887:d=2; afade=in:st=0:d=2, afade=out:st=887:d=2" \
   -c:v libx264 -c:a aac output.mp4
   popd
}

cmm_fadein () 
{
   pushd "/Users/Core/Movies/YouTube"
   ffmpeg -i video.mp4 -filter_complex \
   "fade=in:st=0:d=2; afade=in:st=0:d=2" \
   -c:v libx264 -c:a aac output.mp4
   popd
}

cmm_fadeout () 
{
   pushd "/Users/Core/Movies/YouTube"
   ffmpeg -i input.mp4 -filter_complex \
   "fade=out:st=452:d=2; afade=out:st=452:d=2" \
   -c:v libx264 -c:a aac output.mp4
   popd
}

# USAGE: cmm_sharpen artists/input.png

cmm_sharpen() {
  path=$1
  cd $CMM_SOURCE/assets/images
  convert "$path" -unsharp 0x0.75+0.75+0.008 "$path"
  open "$path"
  cd -
}

cmm_upload() {
  filename=$1
  b2 upload_file corememorymusic ./"$filename" "$filename"
}

cmm_hash() {
  sha=$(echo $1 | openssl dgst -sha256)
  printf "%.*s\n" 8 $sha
}

cmm_concat() {
  cd "/Users/Core/Movies/YouTube"
  ffmpeg -i $1 -i $2 -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [vv] [aa]" \
  -map "[vv]" -map "[aa]" output.mp4
  cd -
}

cmm_calendar()
{
   ncal -NC3
}
