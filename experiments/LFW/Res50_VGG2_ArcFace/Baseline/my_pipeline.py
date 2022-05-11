#================== dataset ======================
from bob.bio.face.config.database.lfw_unrestricted import database
groups = ['dev'] 
database.database.protocol='view2' 

from IPython.core.debugger import set_trace
# set_trace()

# from bob.bio.face.config.baseline.resnet50_vgg2_arcface_2021 import pipeline
from bob.bio.face.config.baseline.resnet50_vgg2_arcface_2021 import load

annotation_type = database.annotation_type
fixed_positions = database.fixed_positions
memory_demanding = (database.memory_demanding if hasattr(database, "memory_demanding") else False)

pipeline = load(annotation_type, fixed_positions)