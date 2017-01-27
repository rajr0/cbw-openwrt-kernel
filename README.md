# Build Linux kernel
```
docker build -t ocp .
docker run -v `pwd`/opt:/opt -it ocp
```

folder './opt' should contain compiled binary (uImage and bcm4708-edgecore-ecw7220-l.dtb)
```
bash-3.2$ ls opt/
bcm4708-edgecore-ecw7220-l.dtb  linux-stable                    uImage
```

folder 'linux-stable' is a full Linux kernel tree used for compilation.


