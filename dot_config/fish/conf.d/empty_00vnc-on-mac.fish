if test -z "$SSH_CONNECTION"
   exit 0
end
if not type -q sw_vers
    exit 0
end

function enable_vnc_service
    sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
        -activate -configure -access -on \
        -clientopts -setvnclegacy -vnclegacy yes \
        -clientopts -setvncpw -vncpw 10117936 \
        -restart -agent -privs -all
end

function disable_vnc_service
    sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
        -deactivate -configure -access -off
end
