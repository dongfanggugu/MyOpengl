//
//  FirstViewController.m
//  MyOpengl
//
//  Created by changhaozhang on 2017/8/31.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "FirstViewController.h"
//#import <OpenGLES/ES2/glext.h>

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
    GLKVector3 normalVector;
} VertexType;

//三角形顶点数据
static const VertexType vertices[] = {
    //LB
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}, {0.0f, 0.0f, 1.0f}},
    //RB
    {{0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}, {0.0f, 0.0f, 1.0f}},
    //LU
    {{-0.5f, 0.5f, 0.0f}, {0.0f, 1.0f}, {0.0f, 0.0f, 1.0f}},
    //RB
    {{0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}, {0.0f, 0.0f, 1.0f}},
    //RU
    {{0.25f, 0.25f, 0.5f}, {1.0f, 1.0f}, {0.41f, -0.41f, 0.82f}},
    //LU
    {{-0.5f, 0.5f, 0.0f}, {0.0f, 1.0f}, {0.0f, 0.0f, 1.0f}}
};

//计算单位法向量
GLKVector3 unitNormal(GLKVector3 v1, GLKVector3 v2) {
    return GLKVector3Normalize(GLKVector3CrossProduct(v1, v2));
}

@interface FirstViewController () {
    GLuint vertexBufferID;
}
//用于设置通用的OpenGL ES环境
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
//OpenGL ES上下文
@property (strong, nonatomic) EAGLContext *context;
@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    GLKVector3 v1 = {0.75, 0.25, -0.25};
    //    GLKVector3 v2 = {-0.25, 0.75, 0.5};
    //    GLKVector3 v3 = unitNormal(v1, v2);
    //    NSLog(@"%@", NSStringFromGLKVector3(v3));
    
    //使用支持OpenGL ES2的上下文
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    //启用元素的默认颜色
    //    self.baseEffect.useConstantColor = GL_TRUE;
    //设置默认颜色
    //    self.baseEffect.constantColor = GLKVector4Make(0.0f, 1.0f, 1.0f, 1.0f);
    
    //生成纹理，由于UIKit的坐标系Y轴与OpenGL ES的Y轴刚好上下颠倒，因此如果图片不加任何处理的话，在贴图后将是颠倒显示
    //    CGImageRef imageRef = [UIImage imageNamed:@"1.jpg"].CGImage;
    //    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef nil error:nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Earth512x256" ofType:@"jpg"];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:nil error:nil];
    //贴图纹理
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    //光照：设置漫反射灯光
    self.baseEffect.light0.enabled = YES;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 0.0f, 1.0f);
    //第四个参数非0表示从该位置发散光线，0表示无穷远处光线的发射方向
    self.baseEffect.light0.position = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
    
    //设置背景色
    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
    
    //1. 生成缓存ID
    glGenBuffers(1, &vertexBufferID);
    //2.
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    //3.
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //4. 启用顶点坐标（x, y, z）
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //5. 类型，成员个数，类型，规范化，间隔，偏移
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(VertexType), NULL + offsetof(VertexType, positionCoords));
    //4.1 启用纹理坐标(u, v)
    //glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    //5.1 设置纹理坐标
    //glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(VertexType), NULL + offsetof(VertexType, textureCoords));
    //4.2 启用法向量
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    //5.2 设置法向量
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(VertexType), NULL + offsetof(VertexType, normalVector));
    
    //6. 绘制
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
