using PyCall: python

run(`$python -m pip install --upgrade pip`)
run(`$python -m pip install "pandas<=0.25.3" tables`)