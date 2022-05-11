dataset=LFW

##############
model=VGG16_Oxford
mkdir $model

../../bin/bob bio roc ../../experiments/$dataset/$model/{Baseline,Biohash/{1_000a,0_600a,0_400a,0_200a,0_100a}/normal}/results/scores-dev -lg \$baseline\$,"$\alpha\$=1.0","$\alpha=0.6$","$\alpha=0.4$","$\alpha=0.2$","$\alpha=0.1$" -la 1e-3 -o $model/roc_normal.pdf --figsize 3.25,2 -ts ' '
../../bin/bob bio roc ../../experiments/$dataset/$model/{Baseline,Biohash/{1_000a,0_600a,0_400a,0_200a,0_100a}/stolen}/results/scores-dev -lg \$baseline\$,"$\alpha=1.0$","$\alpha=0.6$","$\alpha=0.4$","$\alpha=0.2$","$\alpha=0.1$" -la 1e-3 -o $model/roc_stolen.pdf --figsize 3.25,2 -ts ' '

##############
model=FaceNet
mkdir $model

../../bin/bob bio roc ../../experiments/$dataset/$model/{Baseline,Biohash/{1_000,0_600,0_400,0_200,0_100}/normal}/results/scores-dev -lg \$baseline\$,"$\alpha=1.0$","$\alpha=0.6$","$\alpha=0.4$","$\alpha=0.2$","$\alpha=0.1$" -la 1e-3 -o $model/roc_normal.pdf --figsize 3.25,2 -ts ' '
../../bin/bob bio roc ../../experiments/$dataset/$model/{Baseline,Biohash/{1_000,0_600,0_400,0_200,0_100}/stolen}/results/scores-dev -lg \$baseline\$,"$\alpha=1.0$","$\alpha=0.6$","$\alpha=0.4$","$\alpha=0.2$","$\alpha=0.1$" -la 1e-3 -o $model/roc_stolen.pdf --figsize 3.25,2 -ts ' '