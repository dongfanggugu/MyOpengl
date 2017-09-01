//
//  ViewController.m
//  MyOpengl
//
//  Created by changhaozhang on 2017/8/28.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"
#import <OpenGLES/EAGL.h>
#import "sceneUtil.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;

@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexNormalBuffer;

@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexTextureCoordBuffer;

@property (nonatomic, unsafe_unretained) float vertextHeight;

@property (strong, nonatomic) GLKTextureInfo *earthTextureInfo;

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@property (nonatomic, unsafe_unretained) int count;

- (IBAction)btnX:(id)sender;

- (IBAction)btnY:(id)sender;

- (IBAction)btnZ:(id)sender;

- (IBAction)slide:(UISlider *)slider;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupConfig];
}

- (void)setupConfig
{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_DEPTH_TEST);
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
//    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.enabled = YES;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    //第四个参数非0表示从该位置发散光线，0表示无穷远处光线的发射方向
    self.baseEffect.light0.position = GLKVector4Make(-1.0f, -1.0f, 0.5f, 0.0f);
   
    [self drawCube];
}

- (void)drawCube
{
//    GLfloat attrArr[] = {
//        //前面
//        -1.0f, 1.0f, -1.0f,      0.0f, 0.0f, 1.0f, //左上
//        1.0f, 1.0f, -1.0f,       0.0f, 0.0f, 1.0f, //右上
//        -1.0f, -1.0f, -1.0f,     0.0f, 0.0f, 1.0f, //左下
//        1.0f, -1.0f, -1.0f,      0.0f, 0.0f, 1.0f, //右下
//        
//        -0.5f, 0.5f, 0.0f,     1.0f, 0.0f, 0.0f,
//        0.5f, 0.5f, 0.0f,      1.0f, 0.0f, 0.0f,
//        -0.5f, -0.5f, 0.0f,    1.0f, 0.0f, 0.0f,
//        0.5f, -0.5f, 0.0f,     1.0f, 0.0f, 0.0f
//    };
//    
//    GLuint indices[] = {
//        0, 1, 2,
//        1, 2, 3,
//        1, 3, 5,
//        3, 5, 7,
//        0, 2, 4,
//        2, 4, 6,
//        4, 5, 7,
//        4, 6, 7,
//        2, 3, 6,
//        3, 6, 7,
//        0, 1, 4,
//        1, 4, 5
//    };
    
    //顶点数据，前三个是顶点坐标， 中间三个是顶点颜色，    最后两个是纹理坐标
//    GLfloat attrArr[] =
//    {
//        -0.5f, 0.5f, 0.0f,      0.0f, 0.0f, 0.0f,      0.0f, 0.0f, 1.0f, //左上
//        0.5f, 0.5f, 0.0f,       0.0f, 0.0f, 0.0f,      0.0f, 0.0f, 1.0f, //右上
//        -0.5f, -0.5f, 0.0f,     0.0f, 0.0f, 0.0f,      0.0f, 0.0f, 1.0f, //左下
//        0.5f, -0.5f, 0.0f,      1.0f, 0.0f, 0.0f,      0.0f, 0.0f, 1.0f, //右下
//        0.0f, 0.0f, 1.0f,      1.0f, 0.0f, 0.0f,      0.0f, 0.0f, 1.0f  //顶点
//    };
//    //顶点索引
//    GLuint indices[] =
//    {
//        0, 3, 2,
//        0, 1, 3,
//        0, 2, 4,
//        0, 4, 1,
//        2, 3, 4,
//        1, 4, 3
//    };
    
    GLfloat attrArr[] =
    {
        -0.500000, 0.500000, -0.500000, -0.000000, 0.000000, 1.000000,
        -0.500000, 0.000000, -0.500000, -0.000000, 0.000000, 1.000000,
        0.000000, 0.500000, -0.500000, -0.000000, 0.000000, 1.000000,
        
        -0.500000, 0.000000, -0.500000, 0.000000, 0.000000, 1.000000,
        -0.500000, -0.500000, -0.500000, 0.000000, 0.000000, 1.000000,
        0.000000, -0.500000, -0.500000, 0.000000, 0.000000, 1.000000,
        
        0.000000, 0.500000, -0.500000, -0.577350, 0.577350, 0.577350,
        -0.500000, 0.000000, -0.500000, -0.577350, 0.577350, 0.577350,
        0.000000, 0.000000, 0.000000, -0.577350, 0.577350, 0.577350,
        
        0.000000, 0.000000, 0.000000, -0.577350, -0.577350, 0.577350,
        -0.500000, 0.000000, -0.500000, -0.577350, -0.577350, 0.577350,
        0.000000, -0.500000, -0.500000, -0.577350, -0.577350, 0.577350,
        
        0.000000, 0.500000, -0.500000, 0.577350, 0.577350, 0.577350,
        0.000000, 0.000000, 0.000000, 0.577350, 0.577350, 0.577350,
        0.500000, 0.000000, -0.500000, 0.577350, 0.577350, 0.577350,
        
        0.000000, 0.000000, 0.000000, 0.577350, -0.577350, 0.577350,
        0.000000, -0.500000, -0.500000, 0.577350, -0.577350, 0.577350,
        0.500000, 0.000000, -0.500000, 0.577350, -0.577350, 0.577350,
        
        0.500000, 0.500000, -0.500000, 0.000000, 0.000000, 1.000000,
        0.000000, 0.500000, -0.500000, 0.000000, 0.000000, 1.000000,
        0.500000, 0.000000, -0.500000, 0.000000, 0.000000, 1.000000,
        
        0.500000, 0.000000, -0.500000, 0.000000, 0.000000, 1.000000,
        0.000000, -0.500000, -0.500000, 0.000000, 0.000000, 1.000000,
        0.500000, -0.500000, -0.500000, 0.000000, 0.000000, 1.000000
    };
    

    GLuint indices[] =
    {
        0, 1, 3,
        1, 2, 5,
        3, 1, 4,
        4, 1, 5,
        3, 4, 7,
        4, 5, 7,
        6, 3, 7,
        7, 5, 8
    };
    
//    GLfloat attrArr[] =
//    {
//        -0.5f, -0.5f, 0.0f,  0.0f, 0.0f, 1.0f,
//        0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,
//        -0.5f, 0.5f, 0.0f,   0.0f, 0.0f, 1.0f,
//        0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,
//        0.25f, 0.25f, 0.5f,  0.41f, -0.41f, 0.82f,
//        -0.5f, 0.5f, 0.0f,   0.0f, 0.0f, 1.0f
//    };
    
    
    self.count = sizeof(indices) / sizeof(GLuint);
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
    
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 6, (GLfloat *)NULL);
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 6, (GLfloat *)NULL + 3);
    
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60.0f), 1.0f, 0.0f, 0.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30.0f), 0.0f, 0.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, 0.25f);
    
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

int angleX = 0;

- (void)btnX:(id)sender
{
    angleX += 5;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -5);
    
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(angleX));
    
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

int angleY = 0;

- (void)btnY:(id)sender
{
    angleY += 5;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -5);
    
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(angleY));
    
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

int angleZ = 0;

- (void)btnZ:(id)sender
{
    angleZ += 5;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -5);
    
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(angleZ));
    
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.baseEffect prepareToDraw];
    
//    glDrawElements(GL_TRIANGLES, self.count, GL_UNSIGNED_INT, 0);
    glDrawArrays(GL_TRIANGLES, 0, 24);
}


////更新法向量
//- (void)updateNormals
//{
//    SceneTrianglesUpdateFaceNormals(triangles);
//    
//    [self.vertexBuffer
//     reinitWithAttribStride:sizeof(SceneVertex)
//     numberOfVertices:sizeof(triangles) / sizeof(SceneVertex)
//     bytes:triangles];
//}

- (void)bufferData
{
    //    GLfloat aspectRatio = (self.view.bounds.size.width) / (self.view.bounds.size.height);
    
    //    GLfloat aspectRatio = (float)((GLKView *)self.view).drawableWidth / (float)((GLKView *)self.view).drawableHeight;
    
    //    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeFrustum(-1 * aspectRatio, 1 * aspectRatio, -1, 1, 0, 120);
    
    //    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), 1, 0, 200);
    
    //    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0, 0, -1);
    //
    //    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeScale(0.5, 0.5, 0.5);
    //
    //    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(60), 0, 1, 0);
    
    
    //    self.baseEffect.transform.modelviewMatrix =
    //    GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0);
    //
    //    [self setClearColor: GLKVector4Make(
    //                                        0.0f, // Red
    //                                        0.0f, // Green
    //                                        0.0f, // Blue
    //                                        1.0f)];// Alpha
    
    
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                 initWithAttribStride:(3 * sizeof(GLfloat))
                                 numberOfVertices:sizeof(sphereVerts) / (3 * sizeof(GLfloat))
                                 bytes:sphereVerts
                                 usage:GL_STATIC_DRAW];
    
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                               initWithAttribStride:(3 * sizeof(GLfloat))
                               numberOfVertices:sizeof(sphereNormals) / (3 * sizeof(GLfloat))
                               bytes:sphereNormals
                               usage:GL_STATIC_DRAW];
    
    self.vertexTextureCoordBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                     initWithAttribStride:(2 * sizeof(GLfloat))
                                     numberOfVertices:sizeof(sphereTexCoords) / (2 * sizeof(GLfloat))
                                     bytes:sphereTexCoords
                                     usage:GL_STATIC_DRAW];
    
    //地球纹理
    CGImageRef earthImageRef = [[UIImage imageNamed:@"Earth512x256.jpg"] CGImage];
    
    self.earthTextureInfo = [GLKTextureLoader
                             textureWithCGImage:earthImageRef
                             options:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:YES],
                                      GLKTextureLoaderOriginBottomLeft, nil]
                             error:NULL];
}

- (IBAction)slide:(UISlider *)slider
{
    self.vertextHeight = slider.value;
}

@end
