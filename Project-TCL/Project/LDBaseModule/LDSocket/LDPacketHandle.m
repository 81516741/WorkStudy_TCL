//
//  LDPacketHandle.m
//  TestSocket
//
//  Created by lingda on 2018/10/12.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

#import "LDPacketHandle.h"

@implementation LDPacketHandle
NSString * _packetCatch;
NSMutableArray * _xmlArray;

+ (void)load {
    _xmlArray = [NSMutableArray array];
}
+ (NSMutableArray *)xml:(NSString *)packets {
    if (packets.length == 0) {
        return _xmlArray;
    }
    if(nil == _packetCatch) {
        _packetCatch = packets;
    } else {
        _packetCatch = [_packetCatch stringByAppendingString:packets];
    }
    [_xmlArray removeAllObjects];
    NSInteger stringPos;
    NSArray * subStringArray = nil;
    NSArray * subStringArrayEx = nil;
    NSString * strAna = nil;
    NSString * strXml = nil;
    while(nil != _packetCatch)
    {
        if([_packetCatch hasPrefix:@"<iq"])//iq 标签
        {
            subStringArray=[_packetCatch componentsSeparatedByString:@"<iq"];//拆分字符串
            for(stringPos=1;stringPos<subStringArray.count-1;stringPos++)
            {
                strAna=[subStringArray objectAtIndex:stringPos];
                if([strAna hasSuffix:@"</iq>"]||[strAna hasSuffix:@"/>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<iq%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else//不是一个完整的回复包，且不是最后一个拆分段
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<iq%@",strAna];
                    subStringArrayEx=[strXml componentsSeparatedByString:@"</iq>"];//拆分字符串
                    strXml=[((NSString *)[subStringArrayEx objectAtIndex:0]) stringByAppendingString:@"</iq>"];
                    if(subStringArrayEx.count>1)
                    {
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                    }
                    stringPos=subStringArray.count+1;
                }
            }
            if(stringPos>subStringArray.count) //重新开始新的解析过程
            {
                continue;
            }
            //最后一个拆分段的处理
            strAna=[subStringArray objectAtIndex:stringPos];
            if(NSOrderedSame!=[strAna compare:@""])
            {
                if([strAna hasSuffix:@"</iq>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<iq%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else if([strAna hasSuffix:@"/>"]&&(![strAna containsString:@"<"]))//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<iq%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else
                {
                    subStringArrayEx=[strAna componentsSeparatedByString:@"</iq>"];//拆分字符串
                    if(subStringArrayEx.count<2)
                    {
                        subStringArrayEx=[strAna componentsSeparatedByString:@"/>"];//拆分字符串
                        if(subStringArrayEx.count<2)
                        {
                            strXml=[[NSString alloc ]initWithFormat:@"<iq%@",strAna];
                            _packetCatch=strXml;
                            return _xmlArray;
                        }
                        else
                        {
                            strXml=[subStringArrayEx objectAtIndex:0];
                            if([strXml containsString:@"<"])
                            {
                                strAna=[[NSString alloc ]initWithFormat:@"<iq%@",strAna];
                                _packetCatch=strAna;
                                return _xmlArray;
                            }
                            else
                            {
                                strXml=[[NSString alloc ]initWithFormat:@"<iq%@/>",strXml];
                                [_xmlArray addObject:strXml];
                                _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                                continue;
                            }
                        }
                    }
                    else
                    {
                        strXml=[subStringArrayEx objectAtIndex:0];
                        strXml=[[NSString alloc ]initWithFormat:@"<iq%@</iq>",strXml];
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                        continue;
                    }
                }
            }
            _packetCatch=nil;
            return _xmlArray;
        }
        else if([_packetCatch hasPrefix:@"<message"])//message 标签
        {
            subStringArray=[_packetCatch componentsSeparatedByString:@"<message"];//拆分字符串
            for(stringPos=1;stringPos<subStringArray.count-1;stringPos++)
            {
                strAna=[subStringArray objectAtIndex:stringPos];
                if([strAna hasSuffix:@"</message>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<message%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else //不是单个完整的回复包，且不是最后一个拆分段
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<message%@",strAna];
                    subStringArrayEx=[strXml componentsSeparatedByString:@"</message>"];//拆分字符串
                    strXml=[((NSString *)[subStringArrayEx objectAtIndex:0]) stringByAppendingString:@"</message>"];
                    if(subStringArrayEx.count>1)
                    {
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                        
                    }
                    stringPos=subStringArray.count+1;
                }
            }
            if(stringPos>subStringArray.count) //重新开始新的解析过程
            {
                continue;
            }
            //最后一个拆分段的处理
            strAna=[subStringArray objectAtIndex:stringPos];
            if(NSOrderedSame!=[strAna compare:@""])
            {
                if([strAna hasSuffix:@"</message>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<message%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                    
                }
                else if([strAna hasSuffix:@"/>"]&&(![strAna containsString:@"<"]))//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<message%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else
                {
                    subStringArrayEx=[strAna componentsSeparatedByString:@"</message>"];//拆分字符串
                    if(subStringArrayEx.count<2)
                    {
                        strXml=[[NSString alloc ]initWithFormat:@"<message%@",strAna];
                        _packetCatch=strXml;
                        return _xmlArray;
                    }
                    else
                    {
                        strXml=[subStringArrayEx objectAtIndex:0];
                        strXml=[[NSString alloc ]initWithFormat:@"<message%@</message>",strXml];
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                        continue;
                    }
                }
            }
            _packetCatch=nil;
            return _xmlArray;
        }
        else if([_packetCatch hasPrefix:@"<presence"])//presence 标签
        {
            subStringArray=[_packetCatch componentsSeparatedByString:@"<presence"];//拆分字符串
            for(stringPos=1;stringPos<subStringArray.count-1;stringPos++)
            {
                strAna=[subStringArray objectAtIndex:stringPos];
                if([strAna hasSuffix:@"</presence>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<presence%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else //不是一个完整的回复包，且不是最后一个拆分段
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<presence%@",strAna];
                    subStringArrayEx=[strXml componentsSeparatedByString:@"</presence>"];//拆分字符串
                    strXml=[((NSString *)[subStringArrayEx objectAtIndex:0]) stringByAppendingString:@"</presence>"];
                    if(subStringArrayEx.count>1)
                    {
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                    }
                    stringPos=subStringArray.count+1;
                }
            }
            if(stringPos>subStringArray.count) //重新开始新的解析过程
            {
                continue;
            }
            //最后一个拆分段的处理
            strAna=[subStringArray objectAtIndex:stringPos];
            if(NSOrderedSame!=[strAna compare:@""])
            {
                if([strAna hasSuffix:@"</presence>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<presence%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else if([strAna hasSuffix:@"/>"]&&(![strAna containsString:@"<"]))//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<presence%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else
                {
                    subStringArrayEx=[strAna componentsSeparatedByString:@"</presence>"];//拆分字符串
                    if(subStringArrayEx.count<2)
                    {
                        strXml=[[NSString alloc ]initWithFormat:@"<presence%@",strAna];
                        _packetCatch=strXml;
                        return _xmlArray;
                    }
                    else
                    {
                        strXml=[subStringArrayEx objectAtIndex:0];
                        strXml=[[NSString alloc ]initWithFormat:@"<presence%@</presence>",strXml];
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                        continue;
                    }
                }
            }
            _packetCatch=nil;
            return _xmlArray;
        }
        else if([_packetCatch hasPrefix:@"<stream:error"])//stream:error 标签
        {
            subStringArray=[_packetCatch componentsSeparatedByString:@"<stream:error"];//拆分字符串
            for(stringPos=1;stringPos<subStringArray.count-1;stringPos++)
            {
                strAna=[subStringArray objectAtIndex:stringPos];
                if([strAna hasSuffix:@"</<stream:error>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<stream:error%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else //不是一个完整的回复包，且不是最后一个拆分段
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<stream:error%@",strAna];
                    subStringArrayEx=[strXml componentsSeparatedByString:@"</stream:error>"];//拆分字符串
                    strXml=[((NSString *)[subStringArrayEx objectAtIndex:0]) stringByAppendingString:@"</stream:error>"];
                    if(subStringArrayEx.count>1)
                    {
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                    }
                    stringPos=subStringArray.count+1;
                }
            }
            if(stringPos>subStringArray.count) //重新开始新的解析过程
            {
                continue;
            }
            //最后一个拆分段的处理
            strAna=[subStringArray objectAtIndex:stringPos];
            if(NSOrderedSame!=[strAna compare:@""])
            {
                if([strAna hasSuffix:@"</stream:error>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<stream:error%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                    
                }
                else if([strAna hasSuffix:@"/>"]&&(![strAna containsString:@"<"]))//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<stream:error%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else
                {
                    subStringArrayEx=[strAna componentsSeparatedByString:@"</stream:error>"];//拆分字符串
                    if(subStringArrayEx.count<2)
                    {
                        strXml=[[NSString alloc ]initWithFormat:@"<stream:error%@",strAna];
                        _packetCatch=strXml;
                        return _xmlArray;
                    }
                    else
                    {
                        strXml=[subStringArrayEx objectAtIndex:0];
                        strXml=[[NSString alloc ]initWithFormat:@"<stream:error%@</stream:error>",strXml];
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                        continue;
                    }
                }
            }
            _packetCatch=nil;
            return _xmlArray;
        }
        else if([_packetCatch hasPrefix:@"<stream:features"])//stream:features 标签
        {
            subStringArray=[_packetCatch componentsSeparatedByString:@"<stream:features"];//拆分字符串
            for(stringPos=1;stringPos<subStringArray.count-1;stringPos++)
            {
                strAna=[subStringArray objectAtIndex:stringPos];
                if([strAna hasSuffix:@"</<stream:features>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<stream:features%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else //不是一个完整的回复包，且不是最后一个拆分段
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<stream:features%@",strAna];
                    subStringArrayEx=[strXml componentsSeparatedByString:@"</stream:features>"];//拆分字符串
                    strXml=[((NSString *)[subStringArrayEx objectAtIndex:0]) stringByAppendingString:@"</stream:features>"];
                    if(subStringArrayEx.count>1)
                    {
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                    }
                    stringPos=subStringArray.count+1;
                }
            }
            if(stringPos>subStringArray.count) //重新开始新的解析过程
            {
                continue;
            }
            //最后一个拆分段的处理
            strAna=[subStringArray objectAtIndex:stringPos];
            if(NSOrderedSame!=[strAna compare:@""])
            {
                if([strAna hasSuffix:@"</stream:features>"])//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<stream:features%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                    
                }
                else if([strAna hasSuffix:@"/>"]&&(![strAna containsString:@"<"]))//一个完整的回复包
                {
                    strXml=[[NSString alloc ]initWithFormat:@"<stream:features%@",strAna];
                    [_xmlArray addObject:strXml];
                    _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                }
                else
                {
                    subStringArrayEx=[strAna componentsSeparatedByString:@"</stream:features>"];//拆分字符串
                    if(subStringArrayEx.count<2)
                    {
                        strXml=[[NSString alloc ]initWithFormat:@"<stream:features%@",strAna];
                        _packetCatch=strXml;
                        return _xmlArray;
                    }
                    else
                    {
                        strXml=[subStringArrayEx objectAtIndex:0];
                        strXml=[[NSString alloc ]initWithFormat:@"<stream:features%@</stream:features>",strXml];
                        [_xmlArray addObject:strXml];
                        _packetCatch=[_packetCatch substringFromIndex:strXml.length];
                        continue;
                    }
                }
            }
            _packetCatch=nil;
            return _xmlArray;
        }
        else //未知数据，直接丢弃
        {
            if((_packetCatch.length>11)&&([_packetCatch containsString:@"<"]))
            {
                _packetCatch=nil;
            }
            return _xmlArray;
        }
    }
    _packetCatch=nil;
    return _xmlArray;
}
@end
