import os,sys
sys.path.append(os.getcwd())

#================== dataset ======================
from bob.bio.face.config.database.lfw_unrestricted import database
groups = ['dev'] 
database.database.protocol='view2' 

#================== Transformers ==================
########
#================== ArcFace Transformer ===========
# from bob.bio.face.config.baseline.mobilenetv2_msceleb_arcface_2021 import transformer
from bob.bio.face.config.baseline.mobilenetv2_msceleb_arcface_2021 import load

annotation_type = database.annotation_type
fixed_positions = database.fixed_positions
memory_demanding = (database.memory_demanding if hasattr(database, "memory_demanding") else False)

pipeline = load(annotation_type, fixed_positions)
transformer = pipeline.transformer
# set_trace()
#================== Biohash Transformer ===========
from bob.pipelines import wrap, CheckpointWrapper, SampleWrapper
from sklearn.pipeline import make_pipeline

# TO DO BY USER: Define BioHashing parameters:
# **************************************************************************************
# Please modify the SCENARIO and LENGTH parameters according to your requirements: 
SCENARIO = 'n'  # 'n' for Normal, or 'st' for Stolen Token
LENGTH = int(512*0.175)  # BioHash length (i.e., number of bits in the resulting BioHash vector)
# **************************************************************************************

if SCENARIO == 'n':
    USER_SEED = None  # the user seed in the Normal scenario is simply the client id
elif SCENARIO == 'st':
    USER_SEED = 100  # the user seed in the Stolen Token scenario is the same for every biometric sample 


from bob.paper.wifs2021_biohashing_sota_face.Biohashing import BioHash_Transformer, Biohash_System
btp_transformer = BioHash_Transformer(bh_length=LENGTH, user_seed=USER_SEED)
# btp_transformer = wrap(['checkpoint'], btp_transformer, features_dir='btp')


from bob.pipelines.transformers import Linearize
linearize = Linearize()
linearize = wrap(['sample'], linearize)


my_transformer = make_pipeline(*[item for item in transformer], linearize, btp_transformer) 

#================== Algorithm =====================
algorithm = Biohash_System()

#================== pipeline ======================
from bob.bio.base.pipelines.vanilla_biometrics import VanillaBiometricsPipeline
pipeline = VanillaBiometricsPipeline(my_transformer, algorithm)