run_on_grid="True"


root_dir=$(pwd)

if [[ $run_on_grid == "True" ]]
then
    distributed='sge'
else
    distributed=$root_dir'/bob/paper/wifs2021_biohashing_sota_face/local.py'
fi 


for dataset in {LFW,mobio-all}
do
    echo "Dataset: $dataset ----------------"
    for the_model in {VGG16_Oxford,AFFFE,ArcFace,Res50_VGG2_ArcFace,MobileNetV2_MSCeleb_ArcFace_2021,FaceNet,IncResV1_MSCeleb,IncResV2_MSCeleb}
    do
        echo $the_model

        cd $root_dir
        cd experiments
        cd $dataset
        cd $the_model
        cd Baseline
        $root_dir/bin/bob bio pipelines vanilla-biometrics my_pipeline.py -l $distributed -o results -vvv
        
        
        for Bhsh_length in {0_100,0_200,0_300,0_400,0_500,0_600,0_700,0_800,0_900,1_000,2_000}
        do 
            for scenario in {normal,stolen}
            do
                cd $root_dir
                cd experiments
                cd $dataset
                cd $the_model
                cd Biohash
                cd $Bhsh_length
                cd $scenario
                $root_dir/bin/bob bio pipelines vanilla-biometrics my_pipeline.py -l $distributed -o results -vvv
            done
        done
    done


    for the_model in {VGG16_Oxford,AFFFE,ArcFace,Res50_VGG2_ArcFace,MobileNetV2_MSCeleb_ArcFace_2021}
    do
        echo $the_model
        for Bhsh_length in {0_025,0_050,0_075,0_125,0_150,0_175}
        do 
            for scenario in {normal,stolen}
            do
                cd $root_dir
                cd experiments
                cd $dataset
                cd $the_model
                cd Biohash
                cd $Bhsh_length
                cd $scenario
                $root_dir/bin/bob bio pipelines vanilla-biometrics my_pipeline.py -l $distributed -o results -vvv
            done
        done
    done
    
done