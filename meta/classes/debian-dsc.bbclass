python __anonymous() {
    # Fetch .dsc package file
    dsc_uri = (d.getVar('DSC_URI', True) or "").split()
    if len(dsc_uri) == 0:
        return
    try:
        fetcher = bb.fetch2.Fetch(dsc_uri, d)
        fetcher.download()
    except bb.fetch2.BBFetchException as e:
        raise bb.build.FuncFailed(e)

    # Open .dsc file from downloads
    dl_dir = d.getVar('DL_DIR', True) or ""
    dsc_file = (dsc_uri[0].split(";")[0]).split("/")[-1]
    filepath = dl_dir + '/' + dsc_file

    # Parse .dsc for the important fields
    with open(filepath, 'r') as file:
        line = file.readline()
        while line:
            # Get package version and export PV
            if line.startswith('Version:'):
                pv = line.split(": ")[-1].rstrip()
                d.setVar('PV', pv)
                break
            line = file.readline()

        file.close()

# TODO:
# 1. Get the name of tarball and set SRC_URI (lightweight dsc backend)
# 2. Fetch tarball and derive 'debian/control' (full dsc backend)
}
