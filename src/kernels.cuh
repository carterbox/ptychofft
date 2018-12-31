#define PI 3.1415926535
void __global__ mul(float2 *g, float2 *f, float2 *prb, int *scanx, int *scany, 
	int Ntheta, int Nz, int N, int Nscanx, int Nscany, int Nprb, int detx, int dety)
{
	int tx = blockDim.x * blockIdx.x + threadIdx.x;
	int ty = blockDim.y * blockIdx.y + threadIdx.y;
	int tz = blockDim.z * blockIdx.z + threadIdx.z;

	if (tx>=Nprb*Nprb||ty>=Nscanx*Nscany||tz>=Ntheta) return;
	int ix = tx/Nprb;
	int iy = tx%Nprb;
	int m = ty/Nscany;
	int n = ty%Nscany;

	int stx = scanx[m+tz*Nscanx];
	int sty = scany[n+tz*Nscany];
	if(stx==-1||sty==-1) return;

	int shift = (detx-Nprb)/2*dety+(dety-Nprb)/2;
	float2 f0 = f[(sty+iy)+(stx+ix)*N+tz*Nz*N];
	float2 prb0 = prb[iy+ix*Nprb];
	float c = 1/sqrtf(detx*dety);//fft constant
	g[shift+iy+ix*dety+(n+m*Nscany)*detx*dety+tz*detx*dety*Nscanx*Nscany].x = c*prb0.x*f0.x-c*prb0.y*f0.y;
	g[shift+iy+ix*dety+(n+m*Nscany)*detx*dety+tz*detx*dety*Nscanx*Nscany].y = c*prb0.x*f0.y+c*prb0.y*f0.x;

}

void __global__ mula(float2 *f, float2 *g, float2 *prb, int *scanx, int *scany, 
	int Ntheta, int Nz, int N, int Nscanx, int Nscany, int Nprb, int detx, int dety)
{
	int tx = blockDim.x * blockIdx.x + threadIdx.x;
	int ty = blockDim.y * blockIdx.y + threadIdx.y;
	int tz = blockDim.z * blockIdx.z + threadIdx.z;

	if (tx>=Nprb*Nprb||ty>=Nscanx*Nscany||tz>=Ntheta) return;
	int ix = tx/Nprb;
	int iy = tx%Nprb;
	int m = ty/Nscany;
	int n = ty%Nscany;

	int stx = scanx[m+tz*Nscanx];
	int sty = scany[n+tz*Nscany];
	if(stx==-1||sty==-1) return;

	int shift = (detx-Nprb)/2*dety+(dety-Nprb)/2;
	float2 g0 = g[shift+iy+ix*dety+(n+m*Nscany)*detx*dety+tz*detx*dety*Nscanx*Nscany];
	float2 prb0 = prb[iy+ix*Nprb];
	float c = 1/sqrtf(detx*dety);//fft constant
	atomicAdd(&f[(sty+iy)+(stx+ix)*N+tz*Nz*N].x, c*prb0.x*g0.x+c*prb0.y*g0.y);
	atomicAdd(&f[(sty+iy)+(stx+ix)*N+tz*Nz*N].y, c*prb0.x*g0.y-c*prb0.y*g0.x);
}


void __global__ mulamul(float2 *f, float2* ff, float2 *prb, int *scanx, int *scany, 
	int Ntheta, int Nz, int N, int Nscanx, int Nscany, int Nprb, int detx, int dety)
{
	int tx = blockDim.x * blockIdx.x + threadIdx.x;
	int ty = blockDim.y * blockIdx.y + threadIdx.y;
	int tz = blockDim.z * blockIdx.z + threadIdx.z;

	if (tx>=Nprb*Nprb||ty>=Nscanx*Nscany||tz>=Ntheta) return;
	int ix = tx/Nprb;
	int iy = tx%Nprb;
	int m = ty/Nscany;
	int n = ty%Nscany;

	int stx = scanx[m+tz*Nscanx];
	int sty = scany[n+tz*Nscany];
	if(stx==-1||sty==-1) return;

	float2 ff0 = ff[(sty+iy)+(stx+ix)*N+tz*Nz*N];
	float prb0 = prb[iy+ix*Nprb].x*prb[iy+ix*Nprb].x+prb[iy+ix*Nprb].y*prb[iy+ix*Nprb].y;
	atomicAdd(&f[(sty+iy)+(stx+ix)*N+tz*Nz*N].x, prb0*ff0.x);
	atomicAdd(&f[(sty+iy)+(stx+ix)*N+tz*Nz*N].y, prb0*ff0.y);
}




void __global__ updateamp(float2 *g, float* data, 
	int Ntheta, int NscanxNscany, int detxdety)
{
	int tx = blockDim.x * blockIdx.x + threadIdx.x;
	int ty = blockDim.y * blockIdx.y + threadIdx.y;
	int tz = blockDim.z * blockIdx.z + threadIdx.z;

	if (tx>=detxdety||ty>=NscanxNscany||tz>=Ntheta) return;

	int ind = tx+ty*detxdety+tz*detxdety*NscanxNscany;
	float2 g0 = g[ind];
	float data0 = sqrtf(data[ind]);
	float eps = 1e-5;
	float ga = sqrtf(g0.x*g0.x+g0.y*g0.y);
	g[ind].x = g0.x*eps/(ga*eps+eps*eps)*data0;
	g[ind].y = g0.y*eps/(ga*eps+eps*eps)*data0;

}

void __global__ updatepsi(float2* f, float2* ff, float2* ftmp0, float2* ftmp1,
	float2* fff, float rho, float gamma, float maxint, int Ntheta, int Nz,int N)
{
	int tx = blockDim.x * blockIdx.x + threadIdx.x;
	int ty = blockDim.y * blockIdx.y + threadIdx.y;
	int tz = blockDim.z * blockIdx.z + threadIdx.z;

	if (tx>=N||ty>=Nz||tz>=Ntheta) return;

	int ind = tx+ty*N+tz*N*Nz;
	f[ind].x = (1-rho*gamma)*f[ind].x+rho*gamma*(ff[ind].x-fff[ind].x/rho) +
				gamma/2*(ftmp0[ind].x-ftmp1[ind].x)/maxint;
	f[ind].y = (1-rho*gamma)*f[ind].y+rho*gamma*(ff[ind].y-fff[ind].y/rho) +
				gamma/2*(ftmp0[ind].y-ftmp1[ind].y)/maxint;


}
