#map0 = affine_map<() -> (0)>
#map1 = affine_map<(d0) -> (d0)>
#map2 = affine_map<()[s0] -> (s0)>
#map3 = affine_map<(d0, d1) -> (d0, d1)>
#map4 = affine_map<(d0) -> (d0, d0)>


module {
  func @kernel_lu(%arg0: i32, %arg1: memref<2000x2000xf64>) {
    %0 = index_cast %arg0 : i32 to index
    affine.for %arg2 = 0 to %0 {
      affine.for %arg3 = 0 to #map1(%arg2) {
        %1 = alloca() : memref<1xf64>
        call @S0(%1, %arg1, %arg2, %arg3) : (memref<1xf64>, memref<2000x2000xf64>, index, index) -> ()
        affine.for %arg4 = 0 to #map1(%arg3) {
          call @S1(%arg1, %arg2, %arg3, %arg4, %1) : (memref<2000x2000xf64>, index, index, index, memref<1xf64>) -> ()
        }
        call @S2(%arg1, %arg2, %arg3) : (memref<2000x2000xf64>, index, index) -> ()
      }
      affine.for %arg3 = #map1(%arg2) to %0 {
        %1 = alloca() : memref<1xf64>
        call @S3(%1, %arg1, %arg2, %arg3) : (memref<1xf64>, memref<2000x2000xf64>, index, index) -> ()
        affine.for %arg4 = 0 to #map1(%arg2) {
          call @S4(%arg1, %arg2, %arg3, %arg4, %1) : (memref<2000x2000xf64>, index, index, index, memref<1xf64>) -> ()
        }
      }
    }
    return
  }
  func @S0(%arg0: memref<1xf64>, %arg1: memref<2000x2000xf64>, %arg2: index, %arg3: index) attributes {scop.stmt} {
    %0 = affine.load %arg1[%arg2, %arg3] : memref<2000x2000xf64>
    affine.store %0, %arg0[0] : memref<1xf64>
    return
  }
  func @S1(%arg0: memref<2000x2000xf64>, %arg1: index, %arg2: index, %arg3: index, %arg4: memref<1xf64>) attributes {scop.stmt} {
    %0 = affine.load %arg4[0] : memref<1xf64>
    %1 = affine.load %arg0[%arg1, %arg3] : memref<2000x2000xf64>
    %2 = affine.load %arg0[%arg3, %arg2] : memref<2000x2000xf64>
    %3 = mulf %1, %2 : f64
    %4 = subf %0, %3 : f64
    affine.store %4, %arg0[%arg1, %arg2] : memref<2000x2000xf64>
    return
  }
  func @S2(%arg0: memref<2000x2000xf64>, %arg1: index, %arg2: index) attributes {scop.stmt} {
    %0 = affine.load %arg0[%arg1, %arg2] : memref<2000x2000xf64>
    %1 = affine.load %arg0[%arg2, %arg2] : memref<2000x2000xf64>
    %2 = divf %0, %1 : f64
    affine.store %2, %arg0[%arg1, %arg2] : memref<2000x2000xf64>
    return
  }
  func @S3(%arg0: memref<1xf64>, %arg1: memref<2000x2000xf64>, %arg2: index, %arg3: index) attributes {scop.stmt} {
    %0 = affine.load %arg1[%arg2, %arg3] : memref<2000x2000xf64>
    affine.store %0, %arg0[0] : memref<1xf64>
    return
  }
  func @S4(%arg0: memref<2000x2000xf64>, %arg1: index, %arg2: index, %arg3: index, %arg4: memref<1xf64>) attributes {scop.stmt} {
    %0 = affine.load %arg4[0] : memref<1xf64>
    %1 = affine.load %arg0[%arg1, %arg3] : memref<2000x2000xf64>
    %2 = affine.load %arg0[%arg3, %arg2] : memref<2000x2000xf64>
    %3 = mulf %1, %2 : f64
    %4 = subf %0, %3 : f64
    affine.store %4, %arg0[%arg1, %arg2] : memref<2000x2000xf64>
    return
  }
}
