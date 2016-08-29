//
//  MTTypesetter.m
//  iosMath
//
//  Created by Kostub Deshmukh on 6/21/16.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTTypesetter.h"
#import "MTFont+Internal.h"
#import "MTMathListDisplayInternal.h"
#import "MTUnicode.h"

#pragma mark Inter Element Spacing

typedef NS_ENUM(int, MTInterElementSpaceType) {
    kMTSpaceInvalid = -1,
    kMTSpaceNone = 0,
    kMTSpaceThin,
    kMTSpaceNSThin,    // Thin but not in script mode
    kMTSpaceNSMedium,
    kMTSpaceNSThick,
};


NSArray* getInterElementSpaces() {
    static NSArray* interElementSpaceArray = nil;
    if (!interElementSpaceArray) {
        interElementSpaceArray =
        //   ordinary             operator             binary               relation            open                 close               punct               // fraction
        @[ @[@(kMTSpaceNone),     @(kMTSpaceThin),     @(kMTSpaceNSMedium), @(kMTSpaceNSThick), @(kMTSpaceNone),     @(kMTSpaceNone),    @(kMTSpaceNone),    @(kMTSpaceNSThin)],    // ordinary
           @[@(kMTSpaceThin),     @(kMTSpaceThin),     @(kMTSpaceInvalid),  @(kMTSpaceNSThick), @(kMTSpaceNone),     @(kMTSpaceNone),    @(kMTSpaceNone),    @(kMTSpaceNSThin)],    // operator
           @[@(kMTSpaceNSMedium), @(kMTSpaceNSMedium), @(kMTSpaceInvalid),  @(kMTSpaceInvalid), @(kMTSpaceNSMedium), @(kMTSpaceInvalid), @(kMTSpaceInvalid), @(kMTSpaceNSMedium)],  // binary
           @[@(kMTSpaceNSThick),  @(kMTSpaceNSThick),  @(kMTSpaceInvalid),  @(kMTSpaceNone),    @(kMTSpaceNSThick),  @(kMTSpaceNone),    @(kMTSpaceNone),    @(kMTSpaceNSThick)],   // relation
           @[@(kMTSpaceNone),     @(kMTSpaceNone),     @(kMTSpaceInvalid),  @(kMTSpaceNone),    @(kMTSpaceNone),     @(kMTSpaceNone),    @(kMTSpaceNone),    @(kMTSpaceNone)],      // open
           @[@(kMTSpaceNone),     @(kMTSpaceThin),     @(kMTSpaceNSMedium), @(kMTSpaceNSThick), @(kMTSpaceNone),     @(kMTSpaceNone),    @(kMTSpaceNone),    @(kMTSpaceNSThin)],    // close
           @[@(kMTSpaceNSThin),   @(kMTSpaceNSThin),   @(kMTSpaceInvalid),  @(kMTSpaceNSThin),  @(kMTSpaceNSThin),   @(kMTSpaceNSThin),  @(kMTSpaceNSThin),  @(kMTSpaceNSThin)],    // punct
           @[@(kMTSpaceNSThin),   @(kMTSpaceThin),     @(kMTSpaceNSMedium), @(kMTSpaceNSThick), @(kMTSpaceNSThin),   @(kMTSpaceNone),    @(kMTSpaceNSThin),  @(kMTSpaceNSThin)],    // fraction
           @[@(kMTSpaceNSMedium), @(kMTSpaceNSThin),   @(kMTSpaceNSMedium), @(kMTSpaceNSThick), @(kMTSpaceNone),     @(kMTSpaceNone),    @(kMTSpaceNone),    @(kMTSpaceNSThin)]];   // radical
    }
    return interElementSpaceArray;
}


// Get's the index for the given type. If row is true, the index is for the row (i.e. left element) otherwise it is for the column (right element)
NSUInteger getInterElementSpaceArrayIndexForType(MTMathAtomType type, BOOL row) {
    switch (type) {
        case kMTMathAtomOrdinary:
        case kMTMathAtomPlaceholder:   // A placeholder is treated as ordinary
            return 0;
        case kMTMathAtomLargeOperator:
            return 1;
        case kMTMathAtomBinaryOperator:
            return 2;
        case kMTMathAtomRelation:
            return 3;
        case kMTMathAtomOpen:
            return 4;
        case kMTMathAtomClose:
            return 5;
        case kMTMathAtomPunctuation:
            return 6;
        case kMTMathAtomFraction:  // Fraction and inner are treated the same.
        case kMTMathAtomInner:
            return 7;
        case kMTMathAtomRadical: {
            if (row) {
                // Radicals have inter element spaces only when on the left side.
                // Note: This is a departure from latex but we don't want \sqrt{4}4 to look weird so we put a space in between.
                // They have the same spacing as ordinary except with ordinary.
                return 8;
            } else {
                NSCAssert(false, @"Interelement space undefined for radical on the right. Treat radical as ordinary.");
                return -1;
            }
        }
            
        default:
            NSCAssert(false, @"Interelement space undefined for type %lu", (unsigned long)type);
            return -1;
    }
}

#pragma mark - Italics

UTF32Char getItalicized(unichar ch) {
    UTF32Char unicode;
    if (ch == 'h') {
        // special code for h - planks constant
        unicode = kMTUnicodePlanksConstant;
    } else if (ch >= 'a' && ch <= 'z') {
        unicode = kMTUnicodeMathItalicStart + (ch - 'a');
    } else if (ch >= 'A' && ch <= 'Z') {
        unicode = kMTUnicodeMathCapitalItalicStart + (ch - 'A');
    } else if (ch >= kMTUnicodeGreekStart && ch <= kMTUnicodeGreekEnd) {
        // Greek characters
        unicode = kMTUnicodeGreekMathItalicStart + (ch - kMTUnicodeGreekStart);
    } else if (ch >= kMTUnicodeCapitalGreekStart && ch <= kMTUnicodeCapitalGreekEnd) {
        // Capital Greek characters
        unicode = kMTUnicodeGreekMathCapitalItalicStart + (ch - kMTUnicodeCapitalGreekStart);
    } else {
        @throw [NSException exceptionWithName:@"IllegalCharacter"
                                       reason:[NSString stringWithFormat:@"Unknown character %d used as variable.", ch]
                                     userInfo:nil];
    }
    return unicode;
}

static NSString* mathItalicize(NSString* str) {
    NSMutableString* retval = [NSMutableString stringWithCapacity:str.length];
    unichar charBuffer[str.length];
    [str getCharacters:charBuffer range:NSMakeRange(0, str.length)];
    for (int i = 0; i < str.length; ++i) {
        unichar ch = charBuffer[i];
        UTF32Char unicode = getItalicized(ch);
        unicode = NSSwapHostIntToLittle(unicode);
        NSString* charStr = [[NSString alloc] initWithBytes:&unicode length:sizeof(unicode) encoding:NSUTF32LittleEndianStringEncoding];
        [retval appendString:charStr];
    }
    return retval;
}

static void getBboxDetails(CGRect bbox, CGFloat* ascent, CGFloat* descent, CGFloat* width)
{
    if (ascent) {
        *ascent = MAX(0, CGRectGetMaxY(bbox) - 0);
    }
    
    if (descent) {
        // Descent is how much the line goes below the origin. However if the line is all above the origin, then descent can't be negative.
        *descent = MAX(0, 0 - CGRectGetMinY(bbox));
    }
    
    if (width) {
        *width = CGRectGetMaxX(bbox);
    }
}

#pragma mark - MTTypesetter

@implementation MTTypesetter {
    MTFont* _font;
    NSMutableArray<MTDisplay *>* _displayAtoms;
    CGPoint _currentPosition;
    NSMutableAttributedString* _currentLine;
    NSMutableArray* _currentAtoms;   // List of atoms that make the line
    NSRange _currentLineIndexRange;
    MTLineStyle _style;
    MTFont* _styleFont;
    BOOL _cramped;
    BOOL _spaced;
}

+ (MTMathListDisplay *)createLineForMathList:(MTMathList *)mathList font:(MTFont*)font style:(MTLineStyle)style
{
    MTMathList* finalizedList = mathList.finalized;
    // default is not cramped
    return [self createLineForMathList:finalizedList font:font style:style cramped:false];
}

// Internal
+ (MTMathListDisplay *)createLineForMathList:(MTMathList *)mathList font:(MTFont*)font style:(MTLineStyle)style cramped:(BOOL) cramped
{
    return [self createLineForMathList:mathList font:font style:style cramped:cramped spaced:false];
}

// Internal
+ (MTMathListDisplay *)createLineForMathList:(MTMathList *)mathList font:(MTFont*)font style:(MTLineStyle)style cramped:(BOOL) cramped spaced:(BOOL) spaced
{
    NSParameterAssert(font);
    NSArray* preprocessedAtoms = [self preprocessMathList:mathList];
    MTTypesetter *typesetter = [[MTTypesetter alloc] initWithFont:font style:style cramped:cramped spaced:spaced];
    [typesetter createDisplayAtoms:preprocessedAtoms];
    MTMathAtom* lastAtom = mathList.atoms.lastObject;
    MTMathListDisplay* line = [[MTMathListDisplay alloc] initWithDisplays:typesetter->_displayAtoms range:NSMakeRange(0, NSMaxRange(lastAtom.indexRange))];
    return line;
}

+ (UIColor*) placeholderColor
{
    return [UIColor blueColor];
}

- (instancetype)initWithFont:(MTFont*) font style:(MTLineStyle) style cramped:(BOOL) cramped spaced:(BOOL) spaced
{
    self = [super init];
    if (self) {
        _font = font;
        _displayAtoms = [NSMutableArray array];
        _currentPosition = CGPointZero;
        _style = style;
        _cramped = cramped;
        _spaced = spaced;
        _currentLine = [NSMutableAttributedString new];
        _currentAtoms = [NSMutableArray array];
        
        _styleFont = [_font copyFontWithSize:[[self class] getStyleSize:_style font:_font]];
        _currentLineIndexRange = NSMakeRange(NSNotFound, NSNotFound);
    }
    return self;
}

+ (NSArray*) preprocessMathList:(MTMathList*) ml
{
    // Note: Some of the preprocessing described by the TeX algorithm is done in the finalize method of MTMathList.
    // Specifically rules 5 & 6 in Appendix G are handled by finalize.
    // This function does not do a complete preprocessing as specified by TeX either. It removes any special atom types
    // that are not included in TeX and applies Rule 14 to merge ordinary characters.
    NSMutableArray* preprocessed = [NSMutableArray arrayWithCapacity:ml.atoms.count];
    MTMathAtom* prevNode = nil;
    for (MTMathAtom *atom in ml.atoms) {
        if (atom.type == kMTMathAtomVariable) {
            // This is not a TeX type node. TeX does this during parsing the input.
            // switch to using the italic math font
            // We convert it to ordinary
            NSString* italics = mathItalicize(atom.nucleus);
            atom.type = kMTMathAtomOrdinary;
            atom.nucleus = italics;
        } else if (atom.type == kMTMathAtomNumber || atom.type == kMTMathAtomUnaryOperator) {
            // Neither of these are TeX nodes. TeX treats these as Ordinary. So will we.
            atom.type = kMTMathAtomOrdinary;
        }
        
        if (atom.type == kMTMathAtomOrdinary) {
            // This is Rule 14 to merge ordinary characters.
            // combine ordinary atoms together
            if (prevNode && prevNode.type == kMTMathAtomOrdinary && !prevNode.subScript && !prevNode.superScript) {
                [prevNode fuse:atom];
                // skip the current node, we are done here.
                continue;
            }
        }
        
        // TODO: add italic correction here or in second pass?
        prevNode = atom;
        [preprocessed addObject:atom];
    }
    return preprocessed;
}

// returns the size of the font in this style
+ (CGFloat) getStyleSize:(MTLineStyle) style font:(MTFont*) font
{
    CGFloat original = font.fontSize;
    switch (style) {
        case kMTLineStyleDisplay:
        case kMTLineStyleText:
            return original;
            
        case kMTLineStyleScript:
            return original * font.mathTable.scriptScaleDown;
            
        case kMTLineStypleScriptScript:
            return original * font.mathTable.scriptScriptScaleDown;
    }
}

- (void) addInterElementSpace:(MTMathAtom*) prevNode currentType:(MTMathAtomType) type
{
    CGFloat interElementSpace = 0;
    if (prevNode) {
        interElementSpace = [self getInterElementSpace:prevNode.type right:type];
    } else if (_spaced) {
        // For the first atom of a spaced list, treat it as if it is preceded by an open.
        interElementSpace = [self getInterElementSpace:kMTMathAtomOpen right:type];
    }
    _currentPosition.x += interElementSpace;
}

- (void) createDisplayAtoms:(NSArray*) preprocessed
{
    // items should contain all the nodes that need to be layed out.
    // convert to a list of MTDisplayAtoms
    MTMathAtom *prevNode = nil;
    MTMathAtomType lastType = 0;
    for (MTMathAtom* atom in preprocessed) {
        switch (atom.type) {
            case kMTMathAtomNumber:
            case kMTMathAtomVariable:
            case kMTMathAtomUnaryOperator:
                // These should never appear as they should have been removed by preprocessing
                NSAssert(NO, @"These types should never show here as they are removed by preprocessing.");
                break;
                
            case kMTMathAtomAccent:
                NSAssert(NO, @"These math atom types are not yet implemented.");
                break;
                
            case kMTMathAtomBoundary:
                NSAssert(NO, @"A boundary atom should never be inside a mathlist.");
                break;
                
            case kMTMathAtomSpace: {
                // stash the existing layout
                if (_currentLine.length > 0) {
                    [self addDisplayLine];
                }
                MTMathSpace* space = (MTMathSpace*) atom;
                // add the desired space
                _currentPosition.x += space.space * _styleFont.mathTable.muUnit;
                // Since this is extra space, the desired interelement space between the prevAtom
                // and the next node is still preserved. To avoid resetting the prevAtom and lastType
                // we skip to the next node.
                continue;
            }
                
            case kMTMathAtomRadical: {
                // stash the existing layout
                if (_currentLine.length > 0) {
                    [self addDisplayLine];
                }
                MTRadical* rad = (MTRadical*) atom;
                // Radicals are considered as Ord in rule 16.
                [self addInterElementSpace:prevNode currentType:kMTMathAtomOrdinary];
                MTRadicalDisplay* displayRad = [self makeRadical:rad.radicand range:rad.indexRange];
                if (rad.degree) {
                    // add the degree to the radical
                    MTMathListDisplay* degree = [MTTypesetter createLineForMathList:rad.degree font:_styleFont style:kMTLineStypleScriptScript];
                    [displayRad setDegree:degree fontMetrics:_styleFont.mathTable];
                }
                [_displayAtoms addObject:displayRad];
                _currentPosition.x += displayRad.width;
                
                // add super scripts || subscripts
                if (atom.subScript || atom.superScript) {
                    [self makeScripts:atom display:displayRad index:rad.indexRange.location delta:0];
                }
                // change type to ordinary
                //atom.type = kMTMathAtomOrdinary;
                break;
            }
                
            case kMTMathAtomFraction: {
                // stash the existing layout
                if (_currentLine.length > 0) {
                    [self addDisplayLine];
                }
                MTFraction* frac = (MTFraction*) atom;
                [self addInterElementSpace:prevNode currentType:atom.type];
                MTDisplay* display = [self makeFraction:frac];
                [_displayAtoms addObject:display];
                _currentPosition.x += display.width;
                // add super scripts || subscripts
                if (atom.subScript || atom.superScript) {
                    [self makeScripts:atom display:display index:frac.indexRange.location delta:0];
                }
                break;
            }
                
            case kMTMathAtomLargeOperator: {
                // stash the existing layout
                if (_currentLine.length > 0) {
                    [self addDisplayLine];
                }
                [self addInterElementSpace:prevNode currentType:atom.type];
                MTLargeOperator* op = (MTLargeOperator*) atom;
                MTDisplay* display = [self makeLargeOp:op];
                [_displayAtoms addObject:display];
                break;
            }
                
            case kMTMathAtomInner: {
                // stash the existing layout
                if (_currentLine.length > 0) {
                    [self addDisplayLine];
                }
                [self addInterElementSpace:prevNode currentType:atom.type];
                MTInner* inner = (MTInner*) atom;
                MTDisplay* display = nil;
                if (inner.leftBoundary || inner.rightBoundary) {
                    display = [self makeLeftRight:inner];
                } else {
                    display = [MTTypesetter createLineForMathList:inner.innerList font:_font style:_style cramped:_cramped];
                }
                display.position = _currentPosition;
                _currentPosition.x += display.width;
                [_displayAtoms addObject:display];
                // add super scripts || subscripts
                if (atom.subScript || atom.superScript) {
                    [self makeScripts:atom display:display index:atom.indexRange.location delta:0];
                }
                break;
            }
                
            case kMTMathAtomUnderline: {
                // stash the existing layout
                if (_currentLine.length > 0) {
                    [self addDisplayLine];
                }
                // Underline is considered as Ord in rule 16.
                [self addInterElementSpace:prevNode currentType:kMTMathAtomOrdinary];
                atom.type = kMTMathAtomOrdinary;
                
                MTUnderLine* under = (MTUnderLine*) atom;
                MTDisplay* display = [self makeUnderline:under];
                [_displayAtoms addObject:display];
                _currentPosition.x += display.width;
                // add super scripts || subscripts
                if (atom.subScript || atom.superScript) {
                    [self makeScripts:atom display:display index:atom.indexRange.location delta:0];
                }
                break;
            }
                
            case kMTMathAtomOverline: {
                // stash the existing layout
                if (_currentLine.length > 0) {
                    [self addDisplayLine];
                }
                // Overline is considered as Ord in rule 16.
                [self addInterElementSpace:prevNode currentType:kMTMathAtomOrdinary];
                atom.type = kMTMathAtomOrdinary;
                
                MTOverLine* over = (MTOverLine*) atom;
                MTDisplay* display = [self makeOverline:over];
                [_displayAtoms addObject:display];
                _currentPosition.x += display.width;
                // add super scripts || subscripts
                if (atom.subScript || atom.superScript) {
                    [self makeScripts:atom display:display index:atom.indexRange.location delta:0];
                }
                break;
            }
                
            case kMTMathAtomOrdinary:
            case kMTMathAtomBinaryOperator:
            case kMTMathAtomRelation:
            case kMTMathAtomOpen:
            case kMTMathAtomClose:
            case kMTMathAtomPlaceholder:
            case kMTMathAtomPunctuation: {
                // the rendering for all the rest is pretty similar
                // All we need is render the character and set the interelement space.
                if (prevNode) {
                    CGFloat interElementSpace = [self getInterElementSpace:prevNode.type right:atom.type];
                    if (_currentLine.length > 0) {
                        if (interElementSpace > 0) {
                            // add a kerning of that space to the previous character
                            [_currentLine addAttribute:(NSString*) kCTKernAttributeName
                                                 value:[NSNumber numberWithFloat:interElementSpace]
                                                 range:[_currentLine.string rangeOfComposedCharacterSequenceAtIndex:_currentLine.length - 1]];
                        }
                    } else {
                        // increase the space
                        _currentPosition.x += interElementSpace;
                    }
                }
                NSAttributedString* current = nil;
                if (atom.type == kMTMathAtomPlaceholder) {
                    UIColor* color = [MTTypesetter placeholderColor];
                    current = [[NSAttributedString alloc] initWithString:atom.nucleus
                                                              attributes:@{ (NSString*) kCTForegroundColorAttributeName : (id) color.CGColor }];
                } else {
                    current = [[NSAttributedString alloc] initWithString:atom.nucleus];
                }
                [_currentLine appendAttributedString:current];
                // add the atom to the current range
                if (_currentLineIndexRange.location == NSNotFound) {
                    _currentLineIndexRange = atom.indexRange;
                } else {
                    _currentLineIndexRange.length += atom.indexRange.length;
                }
                // add the fused atoms
                if (atom.fusedAtoms) {
                    [_currentAtoms addObjectsFromArray:atom.fusedAtoms];
                } else {
                    [_currentAtoms addObject:atom];
                }
                
                // add super scripts || subscripts
                if (atom.subScript || atom.superScript) {
                    // stash the existing line
                    // We don't check _currentLine.length here since we want to allow empty lines with super/sub scripts.
                    MTCTLineDisplay* line = [self addDisplayLine];
                    CGFloat delta = 0;
                    if (atom.nucleus.length > 0) {
                        // Use the italic correction of the last character.
                        CGGlyph glyph = [self findGlyphForCharacterAtIndex:atom.nucleus.length - 1 inString:atom.nucleus];
                        delta = [_styleFont.mathTable getItalicCorrection:glyph];
                    }
                    if (delta > 0 && !atom.subScript) {
                        // Add a kern of delta
                        _currentPosition.x += delta;
                    }
                    [self makeScripts:atom display:line index:NSMaxRange(atom.indexRange) - 1 delta:delta];
                }
                break;
            }
        }
        lastType = atom.type;
        prevNode = atom;
    }
    if (_currentLine.length > 0) {
        [self addDisplayLine];
    }
    if (_spaced && lastType) {
        // If _spaced then add an interelement space between the last type and close
        MTDisplay* display = [_displayAtoms lastObject];
        CGFloat interElementSpace = [self getInterElementSpace:lastType right:kMTMathAtomClose];
        display.width += interElementSpace;
    }
}

- (MTCTLineDisplay*) addDisplayLine
{
    // add the font
    [_currentLine addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)(_styleFont.ctFont) range:NSMakeRange(0, _currentLine.length)];
    /*NSAssert(_currentLineIndexRange.length == numCodePoints(_currentLine.string),
     @"The length of the current line: %@ does not match the length of the range (%d, %d)",
     _currentLine, _currentLineIndexRange.location, _currentLineIndexRange.length);*/
    
    MTCTLineDisplay* displayAtom = [[MTCTLineDisplay alloc] initWithString:_currentLine position:_currentPosition range:_currentLineIndexRange font:_styleFont atoms:_currentAtoms];
    [_displayAtoms addObject:displayAtom];
    // update the position
    _currentPosition.x += displayAtom.width;
    // clear the string and the range
    _currentLine = [NSMutableAttributedString new];
    _currentAtoms = [NSMutableArray array];
    _currentLineIndexRange = NSMakeRange(NSNotFound, NSNotFound);
    return displayAtom;
}

#pragma mark Spacing

// Returned in units of mu = 1/18 em.
- (int) getSpacingInMu:(MTInterElementSpaceType) type
{
    switch (type) {
        case kMTSpaceInvalid:
            return -1;
        case kMTSpaceNone:
            return 0;
        case kMTSpaceThin:
            return 3;
        case kMTSpaceNSThin:
            return (_style < kMTLineStyleScript) ? 3 : 0;
            
        case kMTSpaceNSMedium:
            return (_style < kMTLineStyleScript) ? 4 : 0;
            
        case kMTSpaceNSThick:
            return (_style < kMTLineStyleScript) ? 5 : 0;
    }
}

- (CGFloat) getInterElementSpace:(MTMathAtomType) left right:(MTMathAtomType) right
{
    NSUInteger leftIndex = getInterElementSpaceArrayIndexForType(left, true);
    NSUInteger rightIndex = getInterElementSpaceArrayIndexForType(right, false);
    NSArray* spaceArray = getInterElementSpaces()[leftIndex];
    NSNumber* spaceTypeObj = spaceArray[rightIndex];
    MTInterElementSpaceType spaceType = spaceTypeObj.intValue;
    NSAssert(spaceType != kMTSpaceInvalid, @"Invalid space between %lu and %lu", (unsigned long)left, (unsigned long)right);
    
    int spaceMultipler = [self getSpacingInMu:spaceType];
    if (spaceMultipler > 0) {
        // 1 em = size of font in pt. space multipler is in multiples mu or 1/18 em
        return spaceMultipler * _styleFont.mathTable.muUnit;
    }
    return 0;
}


#pragma mark Subscript/Superscript

- (MTLineStyle) scriptStyle
{
    switch (_style) {
        case kMTLineStyleDisplay:
        case kMTLineStyleText:
            return kMTLineStyleScript;
        case kMTLineStyleScript:
            return kMTLineStypleScriptScript;
        case kMTLineStypleScriptScript:
            return kMTLineStypleScriptScript;
    }
}

// subscript is always cramped
- (BOOL) subscriptCramped
{
    return true;
}

// superscript is cramped only if the current style is cramped
- (BOOL) superScriptCramped
{
    return _cramped;
}

- (CGFloat) superScriptShiftUp
{
    if (_cramped) {
        return _styleFont.mathTable.superscriptShiftUpCramped;
    } else {
        return _styleFont.mathTable.superscriptShiftUp;
    }
}

// make scripts for the last atom
// index is the index of the element which is getting the sub/super scripts.
- (void) makeScripts:(MTMathAtom*) atom display:(MTDisplay*) display index:(NSUInteger) index delta:(CGFloat) delta
{
    assert(atom.subScript || atom.superScript);
    
    double superScriptShiftUp = 0;
    double subscriptShiftDown = 0;
    
    display.hasScript = YES;
    if (![display isKindOfClass:[MTCTLineDisplay class]]) {
        // get the font in script style
        CGFloat scriptFontSize = [[self class] getStyleSize:self.scriptStyle font:_font];
        MTFont* scriptFont = [_font copyFontWithSize:scriptFontSize];
        MTFontMathTable *scriptFontMetrics = scriptFont.mathTable;
        
        // if it is not a simple line then
        superScriptShiftUp = display.ascent - scriptFontMetrics.superscriptBaselineDropMax;
        subscriptShiftDown = display.descent + scriptFontMetrics.subscriptBaselineDropMin;
    }
    
    if (!atom.superScript) {
        assert(atom.subScript);
        MTMathListDisplay* subscript = [MTTypesetter createLineForMathList:atom.subScript font:_font style:self.scriptStyle cramped:self.subscriptCramped];
        subscript.type = kMTLinePositionSubscript;
        subscript.index = index;
        
        subscriptShiftDown = fmax(subscriptShiftDown, _styleFont.mathTable.subscriptShiftDown);
        subscriptShiftDown = fmax(subscriptShiftDown, subscript.ascent - _styleFont.mathTable.subscriptTopMax);
        // add the subscript
        subscript.position = CGPointMake(_currentPosition.x, _currentPosition.y - subscriptShiftDown);
        [_displayAtoms addObject:subscript];
        // update the position
        _currentPosition.x += subscript.width + _styleFont.mathTable.spaceAfterScript;
        return;
    }
    
    MTMathListDisplay* superScript = [MTTypesetter createLineForMathList:atom.superScript font:_font style:self.scriptStyle cramped:self.superScriptCramped];
    superScript.type = kMTLinePositionSuperscript;
    superScript.index = index;
    superScriptShiftUp = fmax(superScriptShiftUp, self.superScriptShiftUp);
    superScriptShiftUp = fmax(superScriptShiftUp, superScript.descent + _styleFont.mathTable.superscriptBottomMin);
    
    if (!atom.subScript) {
        superScript.position = CGPointMake(_currentPosition.x, _currentPosition.y + superScriptShiftUp);
        [_displayAtoms addObject:superScript];
        // update the position
        _currentPosition.x += superScript.width + _styleFont.mathTable.spaceAfterScript;
        return;
    }
    MTMathListDisplay* subscript = [MTTypesetter createLineForMathList:atom.subScript font:_font style:self.scriptStyle cramped:self.subscriptCramped];
    subscript.type = kMTLinePositionSubscript;
    subscript.index = index;
    subscriptShiftDown = fmax(subscriptShiftDown, _styleFont.mathTable.subscriptShiftDown);
    
    // joint positioning of subscript & superscript
    CGFloat subSuperScriptGap = (superScriptShiftUp - superScript.descent) + (subscriptShiftDown - subscript.ascent);
    if (subSuperScriptGap < _styleFont.mathTable.subSuperscriptGapMin) {
        // Set the gap to atleast as much
        subscriptShiftDown += _styleFont.mathTable.subSuperscriptGapMin - subSuperScriptGap;
        CGFloat superscriptBottomDelta = _styleFont.mathTable.superscriptBottomMaxWithSubscript - (superScriptShiftUp - superScript.descent);
        if (superscriptBottomDelta > 0) {
            // superscript is lower than the max allowed by the font with a subscript.
            superScriptShiftUp += superscriptBottomDelta;
            subscriptShiftDown -= superscriptBottomDelta;
        }
    }
    // The delta is the italic correction above that shift superscript position
    superScript.position = CGPointMake(_currentPosition.x + delta, _currentPosition.y + superScriptShiftUp);
    [_displayAtoms addObject:superScript];
    subscript.position = CGPointMake(_currentPosition.x, _currentPosition.y - subscriptShiftDown);
    [_displayAtoms addObject:subscript];
    _currentPosition.x += MAX(superScript.width + delta, subscript.width) + _styleFont.mathTable.spaceAfterScript;
}

#pragma mark Fractions

- (CGFloat) numeratorShiftUp:(BOOL) hasRule {
    if (hasRule) {
        if (_style == kMTLineStyleDisplay) {
            return _styleFont.mathTable.fractionNumeratorDisplayStyleShiftUp;
        } else {
            return _styleFont.mathTable.fractionNumeratorShiftUp;
        }
    } else {
        if (_style == kMTLineStyleDisplay) {
            return _styleFont.mathTable.stackTopDisplayStyleShiftUp;
        } else {
            return _styleFont.mathTable.stackTopShiftUp;
        }
    }
}

- (CGFloat) numeratorGapMin {
    if (_style == kMTLineStyleDisplay) {
        return _styleFont.mathTable.fractionNumeratorDisplayStyleGapMin;
    } else {
        return _styleFont.mathTable.fractionNumeratorGapMin;
    }
}

- (CGFloat) denominatorShiftDown:(BOOL) hasRule {
    if (hasRule) {
        if (_style == kMTLineStyleDisplay) {
            return _styleFont.mathTable.fractionDenominatorDisplayStyleShiftDown;
        } else {
            return _styleFont.mathTable.fractionDenominatorShiftDown;
        }
    } else {
        if (_style == kMTLineStyleDisplay) {
            return _styleFont.mathTable.stackBottomDisplayStyleShiftDown;
        } else {
            return _styleFont.mathTable.stackBottomShiftDown;
        }
    }
}

- (CGFloat) denominatorGapMin {
    if (_style == kMTLineStyleDisplay) {
        return _styleFont.mathTable.fractionDenominatorDisplayStyleGapMin;
    } else {
        return _styleFont.mathTable.fractionDenominatorGapMin;
    }
}

- (CGFloat) stackGapMin {
    if (_style == kMTLineStyleDisplay) {
        return _styleFont.mathTable.stackDisplayStyleGapMin;
    } else {
        return _styleFont.mathTable.stackGapMin;
    }
}

- (CGFloat) fractionDelimiterHeight {
    if (_style == kMTLineStyleDisplay) {
        return _styleFont.mathTable.fractionDelimiterDisplayStyleSize;
    } else {
        return _styleFont.mathTable.fractionDelimiterSize;
    }
}

- (MTLineStyle) fractionStyle
{
    if (_style == kMTLineStypleScriptScript) {
        return kMTLineStypleScriptScript;
    }
    return _style + 1;
}

- (MTDisplay*) makeFraction:(MTFraction*) frac
{
    // lay out the parts of the fraction
    MTLineStyle fractionStyle = self.fractionStyle;
    MTMathListDisplay* numeratorDisplay = [MTTypesetter createLineForMathList:frac.numerator font:_font style:fractionStyle cramped:false];
    MTMathListDisplay* denominatorDisplay = [MTTypesetter createLineForMathList:frac.denominator font:_font style:fractionStyle cramped:true];
    
    // determine the location of the numerator
    CGFloat numeratorShiftUp = [self numeratorShiftUp:frac.hasRule];
    CGFloat denominatorShiftDown = [self denominatorShiftDown:frac.hasRule];
    CGFloat barLocation = _styleFont.mathTable.axisHeight;
    CGFloat barThickness = (frac.hasRule) ? _styleFont.mathTable.fractionRuleThickness : 0;
    
    if (frac.hasRule) {
        // This is the difference between the lowest edge of the numerator and the top edge of the fraction bar
        CGFloat distanceFromNumeratorToBar = (numeratorShiftUp - numeratorDisplay.descent) - (barLocation + barThickness/2);
        // The distance should at least be displayGap
        CGFloat minNumeratorGap = self.numeratorGapMin;
        if (distanceFromNumeratorToBar < minNumeratorGap) {
            // This makes the distance between the bottom of the numerator and the top edge of the fraction bar
            // at least minNumeratorGap.
            numeratorShiftUp += (minNumeratorGap - distanceFromNumeratorToBar);
        }
        
        // Do the same for the denominator
        // This is the difference between the top edge of the denominator and the bottom edge of the fraction bar
        CGFloat distanceFromDenominatorToBar = (barLocation - barThickness/2) - (denominatorDisplay.ascent - denominatorShiftDown);
        // The distance should at least be denominator gap
        CGFloat minDenominatorGap = self.denominatorGapMin;
        if (distanceFromDenominatorToBar < minDenominatorGap) {
            // This makes the distance between the top of the denominator and the bottom of the fraction bar to be exactly
            // minDenominatorGap
            denominatorShiftDown += (minDenominatorGap - distanceFromDenominatorToBar);
        }
    } else {
        // This is the distance between the numerator and the denominator
        CGFloat clearance = (numeratorShiftUp - numeratorDisplay.descent) - (denominatorDisplay.ascent - denominatorShiftDown);
        // This is the minimum clearance between the numerator and denominator.
        CGFloat minGap = self.stackGapMin;
        if (clearance < minGap) {
            numeratorShiftUp += (minGap - clearance)/2;
            denominatorShiftDown += (minGap - clearance)/2;
        }
    }
    
    MTFractionDisplay *display = [[MTFractionDisplay alloc] initWithNumerator:numeratorDisplay denominator:denominatorDisplay
                                                                     position:_currentPosition range:frac.indexRange];
    
    display.numeratorUp = numeratorShiftUp;
    display.denominatorDown = denominatorShiftDown;
    display.lineThickness = barThickness;
    display.linePosition = barLocation;
    if (!frac.leftDelimiter && !frac.rightDelimiter) {
        return display;
    } else {
        return [self addDelimitersToFractionDisplay:display forFraction:frac];
    }
}

- (MTDisplay*) addDelimitersToFractionDisplay:(MTFractionDisplay*)display forFraction:(MTFraction*) frac
{
    NSAssert(frac.leftDelimiter || frac.rightDelimiter, @"Fraction should have a delimiters to call this function");
    
    NSMutableArray* innerElements = [[NSMutableArray alloc] init];
    CGFloat glyphHeight = self.fractionDelimiterHeight;
    CGPoint position = CGPointZero;
    if (frac.leftDelimiter.length > 0) {
        MTLargeGlyphDisplay* leftGlyph = [self findGlyphForBoundary:frac.leftDelimiter withHeight:glyphHeight];
        leftGlyph.position = position;
        position.x += leftGlyph.width;
        [innerElements addObject:leftGlyph];
    }
    
    display.position = position;
    position.x += display.width;
    [innerElements addObject:display];
    
    if (frac.rightDelimiter.length > 0) {
        MTLargeGlyphDisplay* rightGlyph = [self findGlyphForBoundary:frac.rightDelimiter withHeight:glyphHeight];
        rightGlyph.position = position;
        position.x += rightGlyph.width;
        [innerElements addObject:rightGlyph];
    }
    MTMathListDisplay* innerDisplay = [[MTMathListDisplay alloc] initWithDisplays:innerElements range:frac.indexRange];
    innerDisplay.position = _currentPosition;
    return innerDisplay;
}

#pragma mark - Radicals

- (CGFloat) radicalVerticalGap
{
    if (_style == kMTLineStyleDisplay) {
        return _styleFont.mathTable.radicalDisplayStyleVerticalGap;
    } else {
        return _styleFont.mathTable.radicalVerticalGap;
    }
}

- (MTRadicalDisplay*) makeRadical:(MTMathList*) radicand range:(NSRange) range
{
    MTMathListDisplay* innerDisplay = [MTTypesetter createLineForMathList:radicand font:_font style:_style cramped:YES];
    CGFloat clearance = self.radicalVerticalGap;
    CGFloat radicalRuleThickness = _styleFont.mathTable.radicalRuleThickness;
    CGFloat radicalHeight = innerDisplay.ascent + innerDisplay.descent + clearance + radicalRuleThickness;
    CGFloat glyphAscent, glyphDescent, glyphWidth;
    
    CGGlyph radicalGlyph = [self findGlyphForCharacterAtIndex:0 inString:@"\u221A"];
    CGGlyph glyph = [self findGlyph:radicalGlyph withHeight:radicalHeight glyphAscent:&glyphAscent glyphDescent:&glyphDescent glyphWidth:&glyphWidth];
    
    // Note this is a departure from Latex. Latex assumes that glyphAscent == thickness.
    // Open type math makes no such assumption, and ascent and descent are independent of the thickness.
    // Latex computes delta as descent - (h(inner) + d(inner) + clearance)
    // but since we may not have ascent == thickness, we modify the delta calculation slightly.
    // If the font designer followes Latex conventions, it will be identical.
    CGFloat delta = (glyphDescent + glyphAscent) - (innerDisplay.ascent + innerDisplay.descent + clearance + radicalRuleThickness);
    if (delta > 0) {
        clearance += delta/2;  // increase the clearance to center the radicand inside the sign.
    }
    
    // we need to shift the radical glyph up, to coincide with the baseline of inner.
    // The new ascent of the radical glyph should be thickness + adjusted clearance + h(inner)
    CGFloat radicalAscent = radicalRuleThickness + clearance + innerDisplay.ascent;
    CGFloat shiftUp = radicalAscent - glyphAscent;  // Note: if the font designer followed latex conventions, this is the same as glyphAscent == thickness.
    
    MTRadicalDisplay* radical = [[MTRadicalDisplay alloc] initWitRadicand:innerDisplay glpyh:glyph glyphWidth:glyphWidth position:_currentPosition range:range font:_styleFont];
    radical.ascent = radicalAscent + _styleFont.mathTable.radicalExtraAscender;
    radical.topKern = _styleFont.mathTable.radicalExtraAscender;
    radical.shiftUp = shiftUp;
    radical.lineThickness = radicalRuleThickness;
    // Note: Until we have radical construction from parts, it is possible that glyphAscent+glyphDescent is less
    // than the requested height of the glyph (i.e. radicalHeight), so in the case the innerDisplay has a larger
    // descent we use the innerDisplay's descent.
    radical.descent = MAX(glyphAscent + glyphDescent  - radicalAscent, innerDisplay.descent);
    radical.width = glyphWidth + innerDisplay.width;
    return radical;
}

- (CGGlyph) findGlyph:(CGGlyph) glyph withHeight:(CGFloat) height glyphAscent:(CGFloat*) glyphAscent glyphDescent:(CGFloat*) glyphDescent glyphWidth:(CGFloat*) glyphWidth
{
    CFArrayRef variants = [_styleFont.mathTable copyVerticalVariantsForGlyph:glyph];
    CFIndex numVariants = CFArrayGetCount(variants);
    CGGlyph glyphs[numVariants];
    for (CFIndex i = 0; i < numVariants; i++) {
        CGGlyph glyph = (CGGlyph)CFArrayGetValueAtIndex(variants, i);
        glyphs[i] = glyph;
    }
    CFRelease(variants);
    
    CGRect bboxes[numVariants];
    // Get the bounds for these glyphs
    CTFontGetBoundingRectsForGlyphs(_styleFont.ctFont, kCTFontHorizontalOrientation, glyphs, bboxes, numVariants);
    CGFloat ascent, descent, width;
    for (int i = 0; i < numVariants; i++) {
        CGRect bounds = bboxes[i];
        getBboxDetails(bounds, &ascent, &descent, &width);
        
        if (ascent + descent >= height) {
            *glyphAscent = ascent;
            *glyphDescent = descent;
            *glyphWidth = width;
            return glyphs[i];
        }
    }
    // TODO: none of the glyphs are as large as required. A glyph needs to be constructed using the extenders.
    *glyphAscent = ascent;
    *glyphDescent = descent;
    *glyphWidth = width;
    return glyphs[numVariants - 1];
}

#pragma Large Operators

- (CGGlyph) findGlyphForCharacterAtIndex:(NSUInteger) index inString:(NSString*) str
{
    // Get the character at index taking into account UTF-32 characters
    NSRange range = [str rangeOfComposedCharacterSequenceAtIndex:index];
    unichar chars[range.length];
    [str getCharacters:chars range:range];
    
    // Get the glyph fromt the font
    CGGlyph glyph[range.length];
    bool found = CTFontGetGlyphsForCharacters(_styleFont.ctFont, chars, glyph, range
                                              .length);
    if (!found) {
        // the font did not contain a glyph for our character, so we just return 0 (notdef)
        return 0;
    }
    return glyph[0];
}

- (MTDisplay*) makeLargeOp:(MTLargeOperator*) op
{
    bool limits = (op.limits && _style == kMTLineStyleDisplay);
    CGFloat delta = 0;
    if (op.nucleus.length == 1) {
        CGGlyph glyph = [self findGlyphForCharacterAtIndex:0 inString:op.nucleus];
        if (_style == kMTLineStyleDisplay && glyph != 0) {
            // Enlarge the character in display style.
            glyph = [_styleFont.mathTable getLargerGlyph:glyph];
        }
        // This is be the italic correction of the character.
        delta = [_styleFont.mathTable getItalicCorrection:glyph];
        
        // vertically center
        CGRect bbox = CTFontGetBoundingRectsForGlyphs(_styleFont.ctFont, kCTFontHorizontalOrientation, &glyph, NULL, 1);
        CGFloat ascent, descent, width;
        getBboxDetails(bbox, &ascent, &descent, &width);
        CGFloat shiftDown = 0.5*(ascent - descent) - _styleFont.mathTable.axisHeight;
        MTLargeGlyphDisplay* glyphDisplay = [[MTLargeGlyphDisplay alloc] initWithGlpyh:glyph position:_currentPosition range:op.indexRange font:_styleFont];
        glyphDisplay.ascent = ascent;
        glyphDisplay.descent = descent;
        glyphDisplay.width = width;
        if (op.subScript && !limits) {
            // Remove italic correction from the width of the glyph if
            // there is a subscript and limits is not set.
            glyphDisplay.width -= delta;
        }
        glyphDisplay.shiftDown = shiftDown;
        return [self addLimitsToDisplay:glyphDisplay forOperator:op delta:delta];
    } else {
        // Create a regular node
        NSMutableAttributedString* line = [[NSMutableAttributedString alloc] initWithString:op.nucleus];
        // add the font
        [line addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)(_styleFont.ctFont) range:NSMakeRange(0, line.length)];
        MTCTLineDisplay* displayAtom = [[MTCTLineDisplay alloc] initWithString:line position:_currentPosition range:op.indexRange font:_styleFont atoms:@[ op ]];
        return [self addLimitsToDisplay:displayAtom forOperator:op delta:0];
    }
}

- (MTDisplay*) addLimitsToDisplay:(MTDisplay*) display forOperator:(MTLargeOperator*) op delta:(CGFloat)delta
{
    // If there is no subscript or superscript, just return the current display
    if (!op.subScript && !op.superScript) {
        _currentPosition.x += display.width;
        return display;
    }
    if (op.limits && _style == kMTLineStyleDisplay) {
        // make limits
        MTMathListDisplay *superScript = nil, *subScript = nil;
        if (op.superScript) {
            superScript = [MTTypesetter createLineForMathList:op.superScript font:_font style:self.scriptStyle cramped:self.superScriptCramped];
        }
        if (op.subScript) {
            subScript = [MTTypesetter createLineForMathList:op.subScript font:_font style:self.scriptStyle cramped:self.subscriptCramped];
        }
        NSAssert(superScript || subScript, @"Atleast one of superscript or subscript should have been present.");
        MTLargeOpLimitsDisplay* opsDisplay = [[MTLargeOpLimitsDisplay alloc] initWithNucleus:display upperLimit:superScript lowerLimit:subScript limitShift:delta/2 extraPadding:0];
        if (superScript) {
            CGFloat upperLimitGap = MAX(_styleFont.mathTable.upperLimitGapMin, _styleFont.mathTable.upperLimitBaselineRiseMin - superScript.descent);
            opsDisplay.upperLimitGap = upperLimitGap;
        }
        if (subScript) {
            CGFloat lowerLimitGap = MAX(_styleFont.mathTable.lowerLimitGapMin, _styleFont.mathTable.lowerLimitBaselineDropMin - subScript.ascent);
            opsDisplay.lowerLimitGap = lowerLimitGap;
        }
        opsDisplay.position = _currentPosition;
        opsDisplay.range = op.indexRange;
        _currentPosition.x += opsDisplay.width;
        return opsDisplay;
    } else {
        _currentPosition.x += display.width;
        [self makeScripts:op display:display index:op.indexRange.location delta:delta];
        return display;
    }
}

#pragma mark - Scaling

// TeX has this weird scaling by 2^16 to make all the computations
// using integers rather than floating point. This makes some translations
// of computations a little difficult. Some helper functions to manage scaling.

static const NSInteger kTexScale = 0x10000; // 2^16

- (NSInteger) scale:(CGFloat) f
{
    return (NSInteger) f * kTexScale;
}

- (CGFloat) descale:(NSInteger) i
{
    return ((CGFloat) i) / kTexScale;
}

#pragma mark - Large delimiters

// Delimiter shortfall from plain.tex
static const NSInteger kDelimiterFactor = 901;
static const NSInteger kDelimiterShortfallPoints = 5;

- (MTDisplay*) makeLeftRight:(MTInner*) inner
{
    NSAssert(inner.leftBoundary || inner.rightBoundary, @"Inner should have a boundary to call this function");
    
    MTMathListDisplay* innerListDisplay = [MTTypesetter createLineForMathList:inner.innerList font:_font style:_style cramped:_cramped spaced:YES];
    CGFloat axisHeight = _styleFont.mathTable.axisHeight;
    // delta is the max distance from the axis
    CGFloat delta = MAX(innerListDisplay.ascent - axisHeight, innerListDisplay.descent + axisHeight);
    CGFloat d1 = (delta / 500) * kDelimiterFactor;  // This represents atleast 90% of the formula
    CGFloat d2 = 2 * delta - kDelimiterShortfallPoints;  // This represents a shortfall of 5pt
    // The size of the delimiter glyph should cover at least 90% of the formula or
    // be at most 5pt short.
    CGFloat glyphHeight = MAX(d1, d2);
    
    NSMutableArray* innerElements = [[NSMutableArray alloc] init];
    CGPoint position = CGPointZero;
    if (inner.leftBoundary && inner.leftBoundary.nucleus.length > 0) {
        MTLargeGlyphDisplay* leftGlyph = [self findGlyphForBoundary:inner.leftBoundary.nucleus withHeight:glyphHeight];
        leftGlyph.position = position;
        position.x += leftGlyph.width;
        [innerElements addObject:leftGlyph];
    }
    
    innerListDisplay.position = position;
    position.x += innerListDisplay.width;
    [innerElements addObject:innerListDisplay];
    
    if (inner.rightBoundary && inner.rightBoundary.nucleus.length > 0) {
        MTLargeGlyphDisplay* rightGlyph = [self findGlyphForBoundary:inner.rightBoundary.nucleus withHeight:glyphHeight];
        rightGlyph.position = position;
        position.x += rightGlyph.width;
        [innerElements addObject:rightGlyph];
    }
    MTMathListDisplay* innerDisplay = [[MTMathListDisplay alloc] initWithDisplays:innerElements range:inner.indexRange];
    return innerDisplay;
}

- (MTLargeGlyphDisplay*) findGlyphForBoundary:(NSString*) delimiter withHeight:(CGFloat) glyphHeight
{
    CGFloat glyphAscent, glyphDescent, glyphWidth;
    CGGlyph leftGlyph = [self findGlyphForCharacterAtIndex:0 inString:delimiter];
    CGGlyph glyph = [self findGlyph:leftGlyph withHeight:glyphHeight glyphAscent:&glyphAscent glyphDescent:&glyphDescent glyphWidth:&glyphWidth];
    
    // Create a glyph display
    MTLargeGlyphDisplay* glyphDisplay = [[MTLargeGlyphDisplay alloc] initWithGlpyh:glyph position:CGPointZero range:NSMakeRange(NSNotFound, 0) font:_styleFont];
    glyphDisplay.ascent = glyphAscent;
    glyphDisplay.descent = glyphDescent;
    glyphDisplay.width = glyphWidth;
    // Center the glyph on the axis
    CGFloat shiftDown = 0.5*(glyphAscent - glyphDescent) - _styleFont.mathTable.axisHeight;
    glyphDisplay.shiftDown = shiftDown;
    return glyphDisplay;
}

#pragma mark - Underline/Overline

- (MTDisplay*) makeUnderline:(MTUnderLine*) under
{
    MTMathListDisplay* innerListDisplay = [MTTypesetter createLineForMathList:under.innerList font:_font style:_style cramped:_cramped];
    MTLineDisplay* underDisplay = [[MTLineDisplay alloc] initWithInner:innerListDisplay position:_currentPosition range:under.indexRange];
    // Move the line down by the vertical gap.
    underDisplay.lineShiftUp = -(innerListDisplay.descent + _styleFont.mathTable.underbarVerticalGap);
    underDisplay.lineThickness = _styleFont.mathTable.underbarRuleThickness;
    underDisplay.ascent = innerListDisplay.ascent;
    underDisplay.descent = innerListDisplay.descent + _styleFont.mathTable.underbarVerticalGap + _styleFont.mathTable.underbarRuleThickness + _styleFont.mathTable.underbarExtraDescender;
    underDisplay.width = innerListDisplay.width;
    return underDisplay;
}

- (MTDisplay*) makeOverline:(MTOverLine*) over
{
    MTMathListDisplay* innerListDisplay = [MTTypesetter createLineForMathList:over.innerList font:_font style:_style cramped:YES];
    MTLineDisplay* overDisplay = [[MTLineDisplay alloc] initWithInner:innerListDisplay position:_currentPosition range:over.indexRange];
    overDisplay.lineShiftUp = innerListDisplay.ascent + _styleFont.mathTable.overbarVerticalGap;
    overDisplay.lineThickness = _styleFont.mathTable.underbarRuleThickness;
    overDisplay.ascent = innerListDisplay.ascent + _styleFont.mathTable.overbarVerticalGap + _styleFont.mathTable.overbarRuleThickness + _styleFont.mathTable.overbarExtraAscender;
    overDisplay.descent = innerListDisplay.descent;
    overDisplay.width = innerListDisplay.width;
    return overDisplay;
}

@end
