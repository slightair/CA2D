//
//  Shader.fsh
//  CA2D
//
//  Created by slightair on 2015/12/27.
//  Copyright © 2015年 slightair. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
