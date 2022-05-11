"""
Copyright (c) 2021 Idiap Research Institute, http://www.idiap.ch/
Written by Hatef Otroshi <hatef.otroshi@idiap.ch>

This file is part of Bob toolbox.

Bob is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License version 3 as
published by the Free Software Foundation.

Bob is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Bob. If not, see <http://www.gnu.org/licenses/>.

        *************************

BioHash paper:
    - Andrew Teoh Beng Jin, David Ngo Chek Ling, and Alwyn Goh. "Biohashing: two factor authentication featuring fingerprint data and tokenised random number." Pattern recognition 37, no. 11 (2004): 2245-2255.

Note: If you use this implementation, please cite [at least one of] the following papers:
    - Hatef Otroshi Shahreza, Vedrana Krivokuća Hahn, and Sébastien Marcel. "On the Recognition Performance of BioHashing on state-of-the-art Face Recognition models." In 2021 IEEE International Workshop on Information Forensics and Security (WIFS), pp. 1-6. IEEE, 2021.
    - Hatef Otroshi Shahreza, and Sébastien Marcel. "Towards Protecting and Enhancing Vascular Biometric Recognition methods via Biohashing and Deep Neural Networks." IEEE Transactions on Biometrics, Behavior, and Identity Science, 2021.
    - Vedrana Krivokuća, and Sébastien Marcel. "On the recognition performance of biohash-protected finger vein templates." In Handbook of Vascular Biometrics, pp. 465-480. Springer, Cham, 2020.
"""
from sklearn.base import TransformerMixin, BaseEstimator

from bob.pipelines import  SampleBatch, Sample, SampleSet
import numpy
import scipy.spatial
import hashlib


class BioHash_Transformer(TransformerMixin, BaseEstimator):
    def __init__(self, user_seed=None, bh_length=None):
        self.user_seed = user_seed
        self.bh_length = bh_length
        
    def _more_tags(self):
        return {"stateless": True, "requires_fit": False}

    def fit(self, X, y=None):
        return self
    
    def transform(self, samples):
        
        #sample = sampleBatch_[0]
        # BioHashing
        def _transform(data, reference_id):
            

            if self.user_seed == None: # normal scenario, so user_seed = client_id
                print("Current reference id = %s" % (reference_id))
                
                the_seed = int(hashlib.sha256(reference_id.encode('utf-8')).hexdigest(), 16) % 10**8
                
                print("NORMAL scenario user seed: %s\n" % (the_seed))

                
                bh = self.create_biohash(data, self.bh_length, the_seed)
                
            else: # stolen token scenario, so user_seed will be some randomly generated number (same for every person in the database), specified in config file
                print("STOLEN TOKEN scenario user seed: %s\n" % (self.user_seed))
                bh = self.create_biohash(data, self.bh_length, self.user_seed)
            
            return bh #Sample(bh, biohash_key=user_seed, parent=sample)
        
        #return [Sample(_transform(sample.data, sample.reference_id),btp_key=sample.reference_id,parent=sample) for sample in samples.samples]
        if isinstance(samples[0], SampleSet):
            return [
                    SampleSet(
                        self.transform(sset.samples),
                        parent=sset,
                    )
                    for sset in samples
                ]
        else:
            return [Sample(_transform(sample.data, sample.reference_id),btp_key=sample.reference_id,parent=sample) for sample in samples]
    
    def create_biohash(self, feat_vec, bh_len, user_seed):
        """ Creates a BioHash by projecting the input biometric feature vector onto a set of randomly generated basis vectors and then binarising the resulting vector

        **Parameters:**

        feat_vec (array): The extracted fingervein feture vector

        bh_len (int): The desired length (i.e., number of bits) of the resulting BioHash

        user_seed (int): The seed used to generate the user's specific random projection matrix

        **Returns:**

        biohash (array): The resulting BioHash, which is a protected, binary representation of the input feature vector

        """

        numpy.random.seed(user_seed) # re-seed the random number generator according to the user's specific seed
        rand_mat = numpy.random.rand(len(feat_vec), bh_len) # generate matrix of random values from uniform distribution over [0, 1] 
        orth_mat, _ = numpy.linalg.qr(rand_mat, mode='reduced') # orthonormalise columns of random matrix, mode='reduced' returns orth_mat with size len(feat_vec) x bh_len    
        biohash = numpy.dot(feat_vec, orth_mat)
        thresh = numpy.mean(biohash) # threshold by which to binarise vector of dot products to generate final BioHash
        biohash = numpy.where(biohash > thresh, 1, 0)
        return biohash





from bob.bio.base.pipelines.vanilla_biometrics.abstract_classes import BioAlgorithm

class Biohash_System(BioAlgorithm):
         
    def enroll(self, enroll_features):
        """enroll(enroll_features) -> model

        Enrolls the model BioHash by storing all given input vectors.

        **Parameters:**

        ``enroll_features`` : [:py:class:`numpy.ndarray`]
          The list of BioHashes to enroll the model from.

        **Returns:**

        ``model`` : 2D :py:class:`numpy.ndarray`
          The enrolled BioHash model.
        """
        #return numpy.vstack(sample.data.flatten() for sample in enroll_features)
        return numpy.vstack(enroll_features)


    def score(self, model, probe):
        """score(model, probe) -> score

        This function will compute the Hamming distance between the given model and probe BioHashes.

        **Parameters:**

        model : object
        The model BioHash to compare the probe BioHash with.
        The ``model`` was read using the :py:meth:`read_model` function.

        probe : object
        The probe BioHash to compare the model BioHash with.
        The ``probe`` was read using the :py:meth:`read_feature` function

        **Returns:**

        score : float
        The Hamming distance between ``model`` and ``probe``.
        Higher values define higher similarities.
        """

        
        if model.ndim == 2:
            # we have multiple models, so we use the multiple model scoring
            return numpy.mean(self.score_for_multiple_models(model, probe) )
        else:
            #the_probe = probe.data.flatten()
            the_probe = probe.flatten()
            return scipy.spatial.distance.hamming(model, the_probe) * -1
   
    def score_multiple_biometric_references(self,biometric_references, data):
        """
        It handles the score computation of one probe against multiple biometric references
        This method is called if `allow_scoring_multiple_references` is set to true

        Parameters
        ----------

            biometric_references: list
                List of biometric references to be scored
            data:
                Data used for the creation of ONE BIOMETRIC REFERENCE

        """
        return self.score_for_multiple_models(biometric_references, data)
    
    def score_for_multiple_models(self,models, probe):
    
        scores = [ self.score(model, probe) for model in models ]
        return scores