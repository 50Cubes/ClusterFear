//
//  MFDebug.h
//  StyleTouch
//
//  Created by Kevin Stich on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef StyleTouch_MFDebug_h
#define StyleTouch_MFDebug_h

#import <objc/runtime.h>
#import <mach/mach.h>

#ifdef DEBUG
#define MF_DEBUG_SAFETY_NET_ENABLED 1
#endif

#ifdef DEBUG
#define MFLog(formatString, ...) NSLog(@"-%s line #%d - " formatString, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MFLog(formatString, ...) 
#endif

/*
#ifdef DEBUG
#define MFTryCatch(expression) @try { expression ; } @catch (NSException *exception) { MFLog(@"\n * * * Exception thrown * * * \n * * - \"%@\"\n", exception); }
#else
#define MFTryCatch(expression) expression
#endif
 */

static vm_size_t DebugMemoryUsage()
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS )
    {
        vm_size_t currentMemory = info.resident_size;
        
        return currentMemory;
    }
    
    return 0;
}

static void ClassDumpToURL(NSURL *fileLocation, NSString *keyPhrase)
{
    NSMutableArray *handleMessagesFound = [NSMutableArray new];
    NSMutableDictionary *classMap = [NSMutableDictionary new];
    
    unsigned int classCount = objc_getClassList(NULL, INT32_MAX);
    Class *classArray = malloc(sizeof(id) * classCount);
    objc_getClassList(classArray, classCount);
    
    Method *methodArray = NULL;
    
    for( unsigned int count = 0; count < classCount; count++ )
    {
        NSString *classType = @"-";
        
        Class thisClass = classArray[count];
        NSString *className = NSStringFromClass(thisClass);
        //        NSLog(@"Methods for Class %@", className);
        
        NSMutableArray *buildSet = [NSMutableArray new];
        
    methodListBuild:
        methodArray = class_copyMethodList(thisClass, NULL);
        
        if( methodArray != NULL )
        {
            Method thisMethod = NULL;
            unsigned int methodIterator = 0;
            while( (thisMethod = methodArray[methodIterator++]) != NULL )
            {
                NSString *methodName = NSStringFromSelector(method_getName(thisMethod));
                [buildSet addObject:[NSString stringWithFormat:@"%@%@", classType, methodName]];
                //                NSLog(@"%@\t\tMethod #%u: %@", className, methodIterator, methodName);
                if( [methodName rangeOfString:keyPhrase].location != NSNotFound )
                {
                    [handleMessagesFound addObject:[NSString stringWithFormat:@"Class: %@ Method: %@%@", className, classType, methodName]];
                    //                    NSLog(@"OFFENDER in class %@! ^^^^", thisClass);
                }
            }
            free(methodArray);
        }
        
        if( !class_isMetaClass(thisClass) )
        {
            classType = @"+";
            thisClass = objc_getMetaClass(class_getName(thisClass));
            if( thisClass != NULL )
                goto methodListBuild;
        }
        
        [classMap setObject:[buildSet sortedArrayUsingSelector:@selector(compare:)] forKey:className];
        [buildSet release];
    }
    free(classArray);
    
    NSArray *classNames = [[classMap allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *writeString = [[NSMutableString alloc] initWithCapacity:classCount * 10];
    
    [writeString appendFormat:@"Potential offenders:\n%@", handleMessagesFound];
    [handleMessagesFound release];
    
    for( NSString *className in classNames )
    {
        NSArray *methodNames = [classMap objectForKey:className];
        [writeString appendFormat:@"\nFound %u methods for Class: %@", [methodNames count], className];
        NSUInteger index = 0;
        for( NSString *methodName in methodNames )
            [writeString appendFormat:@"\n\t%@ Method #%u: %@", className, index++, methodName];
    }
    
//    NSURL *fileLocation = [[MFFileUtils rootURLForDocumentsDirectory] URLByAppendingPathComponent:@"classList.txt"];
    [[NSFileManager defaultManager] removeItemAtURL:fileLocation error:nil];
    [writeString writeToURL:fileLocation atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [writeString release];
    [classMap release];
}


#endif
