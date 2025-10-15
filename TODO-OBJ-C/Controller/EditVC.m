//
//  EditVC.m
//  TODO-OBJ-C
//
//  Created by Soha Elgaly on 25/09/2025.
//

#import "EditVC.h"
#import "Task.h"
@interface EditVC ()

@property (weak, nonatomic) IBOutlet UIImageView *todoImage;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;


@property (weak, nonatomic) IBOutlet UITextView *descTextView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *progressSegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property NSMutableArray<Task*>* tasksArray;
@property NSUserDefaults* defaults;
@property NSArray<NSString*>* types;
@property NSArray<NSString*>* status;
@end

@implementation EditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Todo Screen";
    _defaults = [NSUserDefaults standardUserDefaults];
    _types =  [NSArray<NSString*> arrayWithObjects:@"low",@"medium",@"high", nil];
    _status =  [NSArray<NSString*> arrayWithObjects:@"todo",@"inprogress",@"done", nil];
    _tasksArray = [NSMutableArray<Task*> new];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.taskToEdit) {
        if ([self.taskToEdit.status isEqualToString:@"todo"]) {
            self.todoImage.image = [UIImage imageNamed:@"todo"];
        } else if ([self.taskToEdit.status isEqualToString:@"inprogress"]) {
            self.todoImage.image = [UIImage systemImageNamed:@"hourglass.tophalf.filled"];
        } else {
            self.todoImage.image = [UIImage systemImageNamed:@"checkmark.gobackward"];
        }
        
        self.titleTextField.text = self.taskToEdit.name;
        self.descTextView.text = self.taskToEdit.descrption;
        self.prioritySegment.selectedSegmentIndex = [_types indexOfObject:self.taskToEdit.priority];
        self.progressSegment.selectedSegmentIndex = [_status indexOfObject:self.taskToEdit.status];
        self.datePicker.date = self.taskToEdit.date;
        
        [self.saveButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
}
- (IBAction)btnEdit_SaveButtonClicked:(UIButton *)sender {
    
    if (_titleTextField.text.length == 0) {
        [self showAlertWithTitle:@"Missing Information" andMessage:@"Please enter a task title."];
        return;
    }
    
    if (_descTextView.text.length == 0) {
        [self showAlertWithTitle:@"Missing Information" andMessage:@"Please enter a task description."];
        return;
    }
    NSString *selectedStatus = _status[_progressSegment.selectedSegmentIndex];
    NSString *currentStatus = self.taskToEdit ? self.taskToEdit.status : @"todo";
    
    if ([currentStatus isEqualToString:@"inprogress"] && [selectedStatus isEqualToString:@"todo"]) {
        [self showAlertWithTitle:@"Invalid Transition" andMessage:@"You cannot move a task from 'In Progress' back to 'To Do'."];
        return;
    }
    
    if ([currentStatus isEqualToString:@"done"] && [selectedStatus isEqualToString:@"inprogress"]) {
        [self showAlertWithTitle:@"Invalid Transition" andMessage:@"You cannot move a task from 'Done' back to 'In Progress'."];
        return;
    }
    
    
    
    UIAlertController *confirmAlert = [UIAlertController alertControllerWithTitle:@"Confirm Save"
                                                                          message:@"Are you sure you want to save this task?"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self loadTasks];
        [self saveTask];
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    
    [confirmAlert addAction:yesAction];
    [confirmAlert addAction:noAction];
    
    [self presentViewController:confirmAlert animated:YES completion:nil];
}
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)saveTask {
    Task *task = [Task new];
    task.name = _titleTextField.text;
    task.descrption = _descTextView.text;
    task.priority = _types[_prioritySegment.selectedSegmentIndex];
    task.status = _status[_progressSegment.selectedSegmentIndex];
    task.date = _datePicker.date;
    
    BOOL taskUpdated = NO;
    for (NSInteger i = 0; i < _tasksArray.count; i++) {
        Task *existingTask = _tasksArray[i];
        if ([existingTask isEqual:task]) {
            _tasksArray[i] = task;
            taskUpdated = YES;
            break;
        }
    }
    
    if (!taskUpdated) {
        [_tasksArray addObject:task];
    }
    
    NSError *error;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:_tasksArray requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"Error archiving tasks: %@", error.localizedDescription);
        return;
    }
    
    [_defaults setObject:archiveData forKey:@"tasks"];
    [_defaults synchronize];

}


-(void)loadTasks {
    [_tasksArray removeAllObjects];
        NSError *error;
        NSData *savedData = [_defaults objectForKey:@"tasks"];
        if (savedData) {
            NSSet *set = [NSSet setWithObjects:[NSArray class], [Task class], nil];
            _tasksArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
            if (error) {
                NSLog(@"Error unarchiving tasks: %@", error.localizedDescription);
                return;
            }
        }
}

- (void)updateSegmentControlForStatus:(NSString *)status {
    if ([status isEqualToString:@"todo"]) {
        self.progressSegment.enabled = YES;
    } else if ([status isEqualToString:@"inprogress"]) {
        self.progressSegment.enabled = NO;
    } else if ([status isEqualToString:@"done"]) {
        self.progressSegment.enabled = NO;
    } else {
        self.progressSegment.enabled = YES;
    }
}

@end
