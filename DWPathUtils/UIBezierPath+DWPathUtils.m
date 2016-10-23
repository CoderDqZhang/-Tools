//
//  UIBezierPath+DWPathUtils.m
//  DWHUD
//
//  Created by Wicky on 16/10/23.
//  Copyright © 2016年 Wicky. All rights reserved.
//

#import "UIBezierPath+DWPathUtils.h"

@implementation DWPathMaker

-(DWPathMaker *(^)(CGFloat, CGFloat))MoveTo
{
    return ^(CGFloat x,CGFloat y){
        [self.path moveToPoint:CGPointMake(x, y)];
        return self;
    };
}

-(DWPathMaker *(^)(CGFloat, CGFloat))AddLineTo
{
    return ^(CGFloat x,CGFloat y){
        [self.path addLineToPoint:CGPointMake(x, y)];
        return self;
    };
}

-(DWPathMaker *(^)(CGFloat,CGFloat ,CGFloat ,CGFloat ,CGFloat  ,BOOL))AddArcWithAngle
{
    return ^(CGFloat x,CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle,BOOL clockwise){
        [self.path addArcWithCenter:CGPointMake(x, y) radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        return self;
    };
}

-(DWPathMaker *(^)(CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, BOOL))AddArcWithPoint
{
    return ^(CGFloat startX,CGFloat startY,CGFloat endX,CGFloat endY,CGFloat radius,BOOL clockwise){
        [self.path addArcWithStartPoint:CGPointMake(startX, startY) endPoint:CGPointMake(endX, endY) radius:radius clockwise:clockwise];
        return self;
    };
}

-(DWPathMaker *(^)(CGFloat, CGFloat, CGFloat, CGFloat))AddQuadCurve
{
    return ^(CGFloat pointX,CGFloat pointY,CGFloat controlX,CGFloat controlY){
        [self.path addQuadCurveToPoint:CGPointMake(pointX, pointY) controlPoint:CGPointMake(controlX, controlY)];
        return self;
    };
}

-(DWPathMaker *(^)(CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat))AddCurve
{
    return ^(CGFloat pointX,CGFloat pointY,CGFloat controlX1,CGFloat controlY1,CGFloat controlX2,CGFloat controlY2){
        [self.path addCurveToPoint:CGPointMake(pointX, pointY) controlPoint1:CGPointMake(controlX1, controlY1) controlPoint2:CGPointMake(controlX2, controlY2)];
        return self;
    };
}

-(DWPathMaker *(^)())ClosePath
{
    return ^(){
        [self.path closePath];
        return self;
    };
}

@end
@implementation UIBezierPath (DWPathUtils)

+(instancetype)bezierPathWithPathMaker:(void (^)(DWPathMaker *maker))pathMaker
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    if (pathMaker) {
        DWPathMaker * maker = [[DWPathMaker alloc] init];
        maker.path = path;
        pathMaker(maker);
    }
    return path;
}

-(void)addArcWithStartPoint:(CGPoint)startP endPoint:(CGPoint)endP radius:(CGFloat)radius clockwise:(BOOL)clockwise
{
    CGPoint center = [self getCenterFromFirstPoint:startP secondPoint:endP radius:radius clockwise:clockwise];
    CGFloat startA = [self getAngleFromFirstPoint:center secondP:startP clockwise:clockwise];
    CGFloat endA = [self getAngleFromFirstPoint:center secondP:endP clockwise:clockwise];
    [self addArcWithCenter:center radius:radius startAngle:startA endAngle:endA clockwise:clockwise];
}

///根据两点、半径、顺逆时针获取圆心
-(CGPoint)getCenterFromFirstPoint:(CGPoint)firstP
                      secondPoint:(CGPoint)secondP
                           radius:(CGFloat)radius
                        clockwise:(BOOL)clockwise
{
    CGFloat centerX = 0.5 * secondP.x - 0.5 * firstP.x;
    CGFloat centerY = 0.5 * firstP.y - 0.5 * secondP.y;
    
    ///获取相似三角形相似比例
    CGFloat scale = sqrt((pow(radius, 2) - (pow(centerX, 2) + pow(centerY, 2))) / (pow(centerX, 2) + pow(centerY, 2)));
    if (clockwise) {
        return CGPointMake(centerX + centerY * scale + firstP.x, centerY - centerX * scale + firstP.y);
    }
    else
    {
        return CGPointMake(centerX - centerY * scale + firstP.x, centerY + centerX * scale + firstP.y);
    }
}

///获取二点相对一点的角度
-(CGFloat)getAngleFromFirstPoint:(CGPoint)firstP
                         secondP:(CGPoint)secondP
                       clockwise:(BOOL)clockwise
{
    CGFloat deltaX = secondP.x - firstP.x;
    CGFloat deltaY = secondP.y - firstP.y;
    if (deltaY > 0) {
        return acos(deltaX / deltaY);
    }
    if (deltaY == 0) {
        if (deltaX >= 0) {
            return 0;
        }
        else
        {
            return M_PI;
        }
    }
    else
    {
        return acos(deltaX / deltaY) + (clockwise?M_PI:0);
    }
}

@end