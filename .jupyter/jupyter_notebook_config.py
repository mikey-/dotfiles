
###JULIA-WEBIO-CONFIG-BEGIN
import sys, os
if os.path.isfile("${HOME}/.julia/packages/WebIO/Rk8wc/deps/jlstaticserve.py"):
    sys.path.append("${HOME}/.julia/packages/WebIO/Rk8wc/deps")
    c = get_config()
    c.NotebookApp.nbserver_extensions = {
        "jlstaticserve": True
    }
else:
    print("WebIO config in ~/.jupyter/jupyter_notebook_config.py but WebIO plugin not found")
###JULIA-WEBIO-CONFIG-END
