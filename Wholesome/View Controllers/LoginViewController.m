//
//  LoginViewController.m
//  Wholesome
//
//  Created by Anna Thomas on 7/12/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@import Firebase;

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

 


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //set up a gesture recognizer for when user finishes typing so the keyboard can
    //be dismissed
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];

    //set the login button ui
    [self.logInButton.layer setBorderWidth:1.0];
    [self.logInButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.logInButton.layer setCornerRadius:5.0];
}

//gesture tap for keyboard dismissing
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

//when user taps sign up
- (IBAction)didTapSignUp:(id)sender {
    if([self.usernameTextField.text isEqual:@""]) {
        [self showAlertAction:@"Username is empty"];
    }
    
    if([self.passwordTextField.text isEqual:@""]) {
        [self showAlertAction:@"Password is empty"];
    }
 
    [self registerUser];
    
    [[FIRAuth auth] createUserWithEmail:self.usernameTextField.text
                                 password:self.passwordTextField.text
                               completion:^(FIRAuthDataResult * _Nullable authResult,
                                            NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            NSLog(@"%@", error.description);
            NSLog(@"%@", error.userInfo[FIRAuthErrorDomain]);  
            
         }
        
      }];
      // [END create_user]
}

//when user taps login
- (IBAction)didTapLogIn:(id)sender {
    if([self.usernameTextField.text isEqual:@""]) {
        [self showAlertAction:@"Username is empty"];
    }
    
    if([self.passwordTextField.text isEqual:@""]) {
        [self showAlertAction:@"Password is empty"];
    }
    
    [self loginUser];
    
    [[FIRAuth auth] signInWithEmail:self-> _usernameTextField.text
                            password:self->_passwordTextField.text
                          completion:^(FIRAuthDataResult * _Nullable authResult,
                                       NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
         }
     }];
     // [END headless_email_auth]
    
}

//display errors when user cannot login or signup
-(void)showAlertAction:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

//send parse the auth data
- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    //newUser.email = self.emailField.text;
    newUser.password = self.passwordTextField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"toTabBarSegue" sender:self];
        }
    }];
}

//send parse login info
- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self showAlertAction:@"Invalid username/password."];
            
        } else {
            NSLog(@"User logged in successfully");
        
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"toTabBarSegue" sender:self];
        }
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
