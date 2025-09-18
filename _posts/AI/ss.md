

## Min-Max Scaling

공식은 아래와 같으며, 데이터의 범위를 $[0,1]$ 또는 $[-1,1]$ 사이로 스케일링

$$
x'=\frac{x-x_{min}}{x_{max}-x_{min}}
$$

## Standardization

공식은 아래와 같으며, 데이터의 분포를 평균 0, 분산 1로 변환한다.

$$
x'=\frac{x-\mu}{\sigma}
$$

- $x$는 입력, $\mu$는 평균, $\sigma$는 표준편차를 의미한다.

## Covariate Shift