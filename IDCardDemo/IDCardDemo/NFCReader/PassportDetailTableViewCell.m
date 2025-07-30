//
//  PassportDetailTableViewCell.m
//  IDCardDemo
//
//  Created by 张森森 on 2024/8/16.
//  Copyright © 2024 wintone. All rights reserved.
//

#import "PassportDetailTableViewCell.h"
#import "PassportDetailViewController.h"
#import "UIView+UIViewController.h"

@implementation PassportDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.fieldLabel = [[UILabel alloc]init];
        self.fieldLabel.font = [UIFont systemFontOfSize:13];
        self.fieldLabel.frame = CGRectMake(15, 5, 120, 15);
        [self.contentView addSubview:self.fieldLabel];
        
        self.typeImage = [[UIImageView alloc]init];
        self.typeImage.frame = CGRectMake(kScreenWidth-15-15, 7, 15, 12);
        [self.contentView addSubview:self.typeImage];
       
        self.valueText = [[UITextField alloc]init];
        self.valueText.frame = CGRectMake(kScreenWidth -15-15-15-200, 5, 200, 15);
        self.valueText.font = [UIFont systemFontOfSize:13];
        self.valueText.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.valueText];
        [self.valueText addTarget:self action:@selector(TextValueChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return self;
}
- (void)setModel:(PassportDetailModel *)model{
    
    _model = model;
    self.fieldLabel.text = model.field;
    if ([model.field isEqualToString:NSLocalizedString(@"Issuing country code", nil)]) {
        self.valueText.text = self.issuingCountryCode == nil?model.value:[NSString stringWithFormat:@"%@(%@)",self.issuingCountryCode,model.value];
    }else if ([model.field isEqualToString:NSLocalizedString(@"Nationality code", nil)]){
        self.valueText.text = self.NationalityCode == nil?model.value:[NSString stringWithFormat:@"%@(%@)",self.NationalityCode,model.value];
    }else{
        self.valueText.text = model.value;
    }
    [self.fieldLabel sizeToFit];

    if (model.type ==1) {
        self.typeImage.image = [UIImage imageNamed:@"mrz"];
        self.valueText.textColor = [UIColor blackColor];
        self.valueText.userInteractionEnabled = YES;
        
    }else if (model.type ==2){
        self.typeImage.image = [UIImage imageNamed:@"viz"];
        self.valueText.textColor = [UIColor blackColor];
        self.valueText.userInteractionEnabled = YES;
        
    }else if (model.type ==3){
        self.typeImage.image = [UIImage imageNamed:@"passport"];
        self.valueText.textColor = [UIColor lightGrayColor];
        self.valueText.userInteractionEnabled = NO;
    }
    [self layoutSubviews];
}
- (void)TextValueChange:(UITextField*)text{
    
    self.model.value = text.text;
    PassportDetailViewController *passportVC = (PassportDetailViewController*)[self viewController];
    [passportVC replaceTextFieldModelWithmodel:self.model];
}
@end
