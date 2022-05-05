dataset=LFW

##############
model=VGG16_Oxford
mkdir $model

bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000a,0_600a,0_400a,0_200a,0_100a}/normal}/results/scores-dev -lg \$baseline\$,"$\alpha\$=1.0","$\alpha=0.6$","$\alpha=0.4$","$\alpha=0.2$","$\alpha=0.1$" -la 1e-3 -o $model/roc_normal.pdf --figsize 3.25,2 -ts ' '
bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000a,0_600a,0_400a,0_200a,0_100a}/stolen}/results/scores-dev -lg \$baseline\$,"$\alpha=1.0$","$\alpha=0.6$","$\alpha=0.4$","$\alpha=0.2$","$\alpha=0.1$" -la 1e-3 -o $model/roc_stolen.pdf --figsize 3.25,2 -ts ' '

# bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000a,0_600a,0_200a,0_100a,0_400,0_200}/normal}/results/scores-dev -lg \$baseline\$,\$L_{b}=1.0*L_{e}\$,\$L_{b}=0.6*L_{e}\$,\$L_{b}=0.2*L_{e}\$,\$L_{b}=0.1*L_{e}\$,\$L_{b}=0.05*L_{e}\$,\$L_{b}=0.025*L_{e}\$ -la 1e-3 -o $model/roc_normal.pdf --figsize 4,2.5 -ts ' '
# bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000a,0_600a,0_200a,0_100a,0_400,0_200}/stolen}/results/scores-dev -lg \$baseline\$,\$L_{b}=1.0*L_{e}\$,\$L_{b}=0.6*L_{e}\$,\$L_{b}=0.2*L_{e}\$,\$L_{b}=0.1*L_{e}\$,\$L_{b}=0.05*L_{e}\$,\$L_{b}=0.025*L_{e}\$ -la 1e-3 -o $model/roc_stolen.pdf --figsize 4,2.5 -ts ' '


##############
# model=AFFFE
# mkdir $model

# bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000a,0_600a,0_200a,0_100a}/normal}/results/scores-dev -lg \$baseline\$,\$L_{b}=1.0*L_{e}\$,\$L_{b}=0.6*L_{e}\$,\$L_{b}=0.2*L_{e}\$,\$L_{b}=0.1*L_{e}\$ -la 1e-3 -o $model/roc_normal.pdf --figsize 4,2.5 -ts ' '
# bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000a,0_600a,0_200a,0_100a}/stolen}/results/scores-dev -lg \$baseline\$,\$L_{b}=1.0*L_{e}\$,\$L_{b}=0.6*L_{e}\$,\$L_{b}=0.2*L_{e}\$,\$L_{b}=0.1*L_{e}\$ -la 1e-3 -o $model/roc_stolen.pdf --figsize 4,2.5 -ts ' '



##############
# model=ArcFace
# mkdir $model

# bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000,0_600,0_200,0_100,0_050,0_025}/normal}/results/scores-dev -lg \$baseline\$,\$L_{b}=1.0*L_{e}\$,\$L_{b}=0.6*L_{e}\$,\$L_{b}=0.2*L_{e}\$,\$L_{b}=0.1*L_{e}\$,\$L_{b}=0.05*L_{e}\$,\$L_{b}=0.025*L_{e}\$ -la 1e-3 -o $model/roc_normal.pdf --figsize 4,2.5 -ts ' '
# bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000,0_600,0_200,0_100,0_050,0_025}/stolen}/results/scores-dev -lg \$baseline\$,\$L_{b}=1.0*L_{e}\$,\$L_{b}=0.6*L_{e}\$,\$L_{b}=0.2*L_{e}\$,\$L_{b}=0.1*L_{e}\$,\$L_{b}=0.05*L_{e}\$,\$L_{b}=0.025*L_{e}\$ -la 1e-3 -o $model/roc_stolen.pdf --figsize 4,2.5 -ts ' '


# model=Res50_VGG2_ArcFace
# mkdir $model

# bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000,0_600,0_400,0_200,0_100}/normal}/results/scores-dev -lg \$baseline\$,\$L_{b}=1.0*L_{e}\$,\$L_{b}=0.6*L_{e}\$,\$L_{b}=0.4*L_{e}\$,\$L_{b}=0.2*L_{e}\$,\$L_{b}=0.1*L_{e}\$ -la 1e-3 -o $model/roc_normal.pdf --figsize 4,2.5 -ts ' '
# bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000,0_600,0_400,0_200,0_100}/stolen}/results/scores-dev -lg \$baseline\$,\$L_{b}=1.0*L_{e}\$,\$L_{b}=0.6*L_{e}\$,\$L_{b}=0.4*L_{e}\$,\$L_{b}=0.2*L_{e}\$,\$L_{b}=0.1*L_{e}\$ -la 1e-3 -o $model/roc_stolen.pdf --figsize 4,2.5 -ts ' '


##############
model=FaceNet
mkdir $model

bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000,0_600,0_400,0_200,0_100}/normal}/results/scores-dev -lg \$baseline\$,"$\alpha=1.0$","$\alpha=0.6$","$\alpha=0.4$","$\alpha=0.2$","$\alpha=0.1$" -la 1e-3 -o $model/roc_normal.pdf --figsize 3.25,2 -ts ' '
bob bio roc ../../$dataset/$model/models/{Baseline,Biohash/{1_000,0_600,0_400,0_200,0_100}/stolen}/results/scores-dev -lg \$baseline\$,"$\alpha=1.0$","$\alpha=0.6$","$\alpha=0.4$","$\alpha=0.2$","$\alpha=0.1$" -la 1e-3 -o $model/roc_stolen.pdf --figsize 3.25,2 -ts ' '
