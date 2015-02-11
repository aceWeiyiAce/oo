//
//  Paixu.m
//  JiuBa
//
//  Created by iFangSoft on 15/1/29.
//
//

#import "Paixu.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "PhoneFriends.h"

@implementation Paixu
+(NSMutableArray *)zhongWenPaiXu:(NSMutableArray *)newArray{
    
    //中文排序。
    
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    
    for(int i=0;i<[newArray count];i++){
        
        ChineseString *chineseString=[[ChineseString alloc]init];
        
        chineseString.string=[NSString stringWithString:[newArray objectAtIndex:i] ];
        
        if(chineseString.string==nil){
            
            chineseString.string=@"";
            
        }
        
        if(![chineseString.string isEqualToString:@""]){
            
            NSString *pinYinResult=[NSString string];
            
            for(int j=0;j<chineseString.string.length;j++){
                
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];                }
            
            chineseString.pinYin=pinYinResult;
            
        }else{
            
            chineseString.pinYin=@"";
            
        }
        
        [chineseStringsArray addObject:chineseString];
        
    }
    
    
    
    //Step2输出
    
    //    NSLog(@"\n\n\n转换为拼音首字母后的NSString数组");
    
    for(int i=0;i<[chineseStringsArray count];i++){
        
        ChineseString *chineseString=[chineseStringsArray objectAtIndex:i];
        
        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);        }
    
    //Step3:按照拼音首字母对这些Strings进行排序
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin"ascending:YES]];
    
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    
    //Step4输出
    
    //    NSLog(@"\n\n\n按照拼音首字母后的NSString数组");
    
    for(int i=0;i<[chineseStringsArray count];i++){
        
        ChineseString *chineseString=[chineseStringsArray objectAtIndex:i];
        
        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);        }
    
    // Step4:如果有需要，再把排序好的内容从ChineseString类中提取出来
    
    NSMutableArray *result=[NSMutableArray array];
    
    for(int i=0;i<[chineseStringsArray count];i++){
        
        [result addObject:((ChineseString*)[chineseStringsArray objectAtIndex:i]).string];        }
    
    //Step5输出
    
    NSLog(@"\n\n\n最终结果:");    
    
    for(int i=0;i<[result count];i++){    
        
        NSLog(@"%@",[result objectAtIndex:i]);   
        
    }                //程序结束    
    
    return chineseStringsArray;
    
}

@end
