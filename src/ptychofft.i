/*interface*/
%module ptychofft

%{
#define SWIG_FILE_WITH_INIT
#include "ptychofft.cuh"
%}

%include "numpy.i"

%init %{
import_array();
%}
class ptychofft
{
	size_t N;
	size_t Ntheta;
	size_t Nz;
	size_t Nscanx;
	size_t Nscany;
	size_t detx;
	size_t dety;
	size_t Nprb;

	float2* f;
	float2* g;
	float2* prb; 
	int* scanx; 
	int* scany; 
	float2* ff;
	float2* fff;
	float* data;
	float2* ftmp0;
	float2* ftmp1;
	
	cufftHandle plan2dfwd;
	cufftHandle plan2dadj;

public:
	ptychofft(size_t Ntheta, size_t Nz, size_t N, 
		size_t Nscanx, size_t Nscany, size_t detx, size_t dety, size_t Nprb);
	~ptychofft();	
	void setobjc(int* scanx_, int* scany_, float2* prb_);
	void fwdc(float2* g_, float2* f_);
	void adjc(float2* f_, float2* g_);
	void adjfwd_prbc(float2* f_, float2* ff_);
	void update_ampc(float2* f_, float* data_);
	void grad_ptychoc(float2* f_,float* data_, float2* ff_, float2* fff_, float rho, 
	float gamma, float maxint, int niter);

	// python wrap

	%apply (float2 *IN_ARRAY1, int DIM1) {(float2* theta_, int N20)};
	%apply (int *IN_ARRAY2, int DIM1, int DIM2) {(int* scanx_, int N30, int N31)};
	%apply (int *IN_ARRAY2, int DIM1, int DIM2) {(int* scany_, int N40, int n41)};
	%apply (float2 *IN_ARRAY2, int DIM1, int DIM2) {(float2* prb_, int N50, int N51)};
	
	void setobj(
			int* scanx_, int N30, int N31,
			int* scany_, int N40, int n41,
			float2* prb_, int N50, int N51);

    %apply (float2 *INPLACE_ARRAY4, int DIM1, int DIM2, int DIM3, int DIM4) {(float2* g_, int N00, int N01, int N02, int N03)};
	%apply (float2 *IN_ARRAY3, int DIM1, int DIM2, int DIM3) {(float2* f_, int N10, int N11, int N12)};
	void fwd(float2* g_, int N00, int N01, int N02, int N03,
			float2* f_, int N10, int N11, int N12);
	%clear (float2* g_, int N00, int N01, int N02, int N03);
	%clear (float2* f_, int N10, int N11, int N12);

    %apply (float2 *IN_ARRAY4, int DIM1, int DIM2, int DIM3, int DIM4) {(float2* g_, int N00, int N01, int N02, int N03)};
	%apply (float2 *INPLACE_ARRAY3, int DIM1, int DIM2, int DIM3) {(float2* f_, int N10, int N11, int N12)};
	void adj(float2* f_, int N10, int N11, int N12,
			float2* g_, int N00, int N01, int N02, int N03);
	%clear (float2* g_, int N00, int N01, int N02, int N03);
	%clear (float2* f_, int N10, int N11, int N12);

	%apply (float2 *INPLACE_ARRAY3, int DIM1, int DIM2, int DIM3) {(float2* f_, int N10, int N11, int N12)};
	%apply (float2 *IN_ARRAY3, int DIM1, int DIM2, int DIM3) {(float2* ff_, int N60, int N61, int N62)};
	void adjfwd_prb(float2* f_, int N10, int N11, int N12,
			float2* ff_, int N60, int N61, int N62);
	%clear (float2* f_, int N10, int N11, int N12);
	%clear (float2* ff_, int N60, int N61, int N62);

    %apply (float2 *INPLACE_ARRAY4, int DIM1, int DIM2, int DIM3, int DIM4) {(float2* g_, int N00, int N01, int N02, int N03)};	
	%apply (float *IN_ARRAY4, int DIM1, int DIM2, int DIM3, int DIM4) {(float* data_, int N70, int N71, int N72, int N73)};	
	void update_amp(float2* g_, int N00, int N01, int N02, int N03,
			float* data_, int N70, int N71, int N72, int N73);
	%clear (float2* g_, int N00, int N01, int N02, int N03);
	%clear (float* data_, int N70, int N71, int N72, int N73);

	%apply (float2 *INPLACE_ARRAY3, int DIM1, int DIM2, int DIM3) {(float2* f_, int N10, int N11, int N12)};
	%apply (float2 *IN_ARRAY3, int DIM1, int DIM2, int DIM3) {(float2* ff_, int N60, int N61, int N62)};
	%apply (float2 *IN_ARRAY3, int DIM1, int DIM2, int DIM3) {(float2* fff_, int N80, int N81, int N82)};
	%apply (float *IN_ARRAY4, int DIM1, int DIM2, int DIM3, int DIM4) {(float* data_, int N70, int N71, int N72, int N73)};		
	void grad_ptycho(
		float2* f_, int N10, int N11, int N12,
		float* data_, int N70, int N71, int N72, int N73,
		float2* ff_, int N60, int N61, int N62,
		float2* fff_, int N80, int N81, int N82,
		float rho, float gamma, float maxint, int niter);
	%clear (float2* f_, int N10, int N11, int N12);
	%clear (float2* ff_, int N60, int N61, int N62);
	%clear (float2* fff_, int N80, int N81, int N82);
	%clear (float* data_, int N70, int N71, int N72, int N73);

};


