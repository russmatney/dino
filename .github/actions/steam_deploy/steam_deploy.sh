#!/bin/bash
set -euo pipefail

# based on https://raw.githubusercontent.com/game-ci/steam-deploy/main/steam_deploy.sh

steamdir=${STEAM_HOME:-$HOME/Steam}
manifest_path=$(pwd)/build/steam_dino_linux_build.vdf

echo "steamdir: $steamdir"
echo "manifest_path: $manifest_path"

if [ -n "$steam_totp" ]; then
  echo ""
  echo "#################################"
  echo "#     Using SteamGuard TOTP     #"
  echo ""
fi

# test login
steamcmd +set_steam_guard_code "$steam_totp" +login "$steam_username" "$steam_password" "$steam_totp" +quit;

ret=$?
if [ $ret -eq 0 ]; then
    echo ""
    echo "#################################"
    echo "#        Successful login       #"
    echo ""
else
      echo ""
      echo "#################################"
      echo "#        FAILED login           #"
      echo ""
      echo "Exit code: $ret"

      exit $ret
fi

echo ""
echo "######## Uploading build ########"
echo ""

steamcmd +login "$steam_username" +run_app_build "$manifest_path" +quit || (
    echo ""
    echo "#################################"
    echo "#             Errors            #"
    # echo "#################################"
    # echo ""
    # echo "Listing current folder"
    # echo ""
    # ls -alh
    # echo ""
    # echo "Listing logs folder:"
    # echo ""
    # ls -Ralph "$steamdir/logs/"

    # for f in "$steamdir"/logs/*; do
    #   if [ -e "$f" ]; then
    #     echo "######## $f"
    #     cat "$f"
    #     echo
    #   fi
    # done

    # echo ""
    # echo "Displaying error log"
    # echo ""
    # cat "$steamdir/logs/stderr.txt"
    # echo ""
    # echo "Displaying bootstrapper log"
    # echo ""
    # cat "$steamdir/logs/bootstrap_log.txt"
    # echo ""
    # echo "#################################"
    # echo "#             Output            #"
    # echo ""
    # ls -Ralph BuildOutput

    # for f in BuildOutput/*.log; do
    #   echo "######## $f"
    #   cat "$f"
    #   echo
    # done

    exit 1
  )

echo "manifest=${manifest_path}" >> $GITHUB_OUTPUT
