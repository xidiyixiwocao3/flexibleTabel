//
//  ViewController.m
//  flexibleTable
//
//  Created by 许远备 on 2018/8/29.
//  Copyright © 2018年 me. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    int _flag;
    
    CGFloat _height;
}
@property (nonatomic ) CGRect textViewFrame;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* strArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    _strArray= [[NSMutableArray alloc]initWithArray:@[@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa",@"aaa"]];
    self.view.backgroundColor=[UIColor grayColor];
    UITableView* tableView=[[UITableView alloc]initWithFrame:CGRectMake(30, 30, self.view.bounds.size.width-60, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor orangeColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    _tableView=tableView;
    
    [self.view addSubview:_tableView];
    UITextView* textView=[[UITextView alloc]initWithFrame:CGRectMake(100, 100, 200, 50) textContainer:nil];
    

    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
 
    if([self.view isFirstResponder])
    {
        NSLog(@"self.view isFirstResponder");
    }
    if([textView isFirstResponder])
    {
        NSLog(@"self.tabelview isFirstResponer");
    }
    
    
    if([textView isFirstResponder])
    {
        NSLog(@"isFirstResponer");
    }
    if([self isFirstResponder])
    {
        NSLog(@"selffirstres");
    }
    
    
//    if([_tableView becomeFirstResponder])
//    {
//        if( [cell becomeFirstResponder])
//        {
//            for(UIView* view in cell.contentView.subviews)
//            {
//                if([view isKindOfClass:[UITextView class]])
//                {
//                    [view becomeFirstResponder];
//                }
//            }
//        }
//    }
//
    
//    [cell becomeFirstResponder];
//    for(UIView* view in cell.contentView.subviews)
//    {
//        if([view isKindOfClass:[UITextView class]])
//        {
//            [view becomeFirstResponder];
//        }
//    }
    
}
-(void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    NSIndexPath* indexpath=[NSIndexPath indexPathForRow:_flag inSection:0];
    UITableViewCell* cell=[self.tableView cellForRowAtIndexPath:indexpath];
//    UITableViewCell* cell=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    if(cell)
    {
        UITextView* textview=cell.contentView.subviews[0];
        NSLog(@"text=%@",textview.text);
        [textview becomeFirstResponder];
    }
    NSLog(@"view did appear");

}
-(void)viewWillAppear:(BOOL)animated
{
     NSLog(@"view will appear");
    [super viewWillAppear:animated];
    
    UITableViewCell* cell=[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    if(cell)
    {
        UITextView* textview=cell.contentView.subviews[0];
        NSLog(@"text=%@",textview.text);
    }
    NSLog(@"view will appear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note{
    CGRect frame = self.textViewFrame;
    //获取键盘高度
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //140是文本框的高度，如果你的文本框高度不一样，则可以进行不同的调整
    CGFloat offSet = frame.origin.y + self.textViewFrame.size.height - (self.view.frame.size.height - kbSize.height);
    //将试图的Y坐标向上移动offset个单位，以使界面腾出开的地方用于软键盘的显示
    if (offSet > 0.01) {
     //   WEAKSELF
        typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.tableView.contentOffset = CGPointMake(0, offSet);
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[[UITableViewCell alloc]init];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor purpleColor];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    UITextView* textView=[[UITextView alloc]initWithFrame:CGRectMake(15, 5,100, cell.frame.size.height-10) textContainer:nil];
    textView.tag=indexPath.row;
    textView.text=_strArray[indexPath.row];
    
    [textView sizeToFit];//使用sizeToFit方法处理textview随输入大小变化以及自动换行问题
    
    _height=textView.frame.size.height; //_height记录textview高度
    textView.delegate=self;
    textView.scrollEnabled=NO;

    [cell.contentView addSubview:textView];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_height==0)
    {
        return 50;
    }
    else{
        return _height+10;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    for(UIView* view in cell.contentView.subviews)
    {
        if([view isKindOfClass:[UITextView class]])
        {
            [view becomeFirstResponder];
        }
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewFrame = [textView convertRect:textView.frame toView:self.view];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{

    _strArray[textView.tag]=textView.text;
    _flag=(int)textView.tag;
    [self.tableView reloadData];
    [self viewDidAppear:YES];
   
}

@end
