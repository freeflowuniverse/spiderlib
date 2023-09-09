module flowbite

pub fn email_input() InputWithLabel {
	return InputWithLabel {
		name: 'email'
		label: 'Your Email'
		placeholder: 'name@company.com'
	}
}

pub fn name_input() InputWithLabel {
	return InputWithLabel {
		name: 'name'
		label: 'Your Name'
		placeholder: 'Firstname Lastname'
	}
}

pub fn code_input() InputWithLabel {
	return InputWithLabel {
		name: 'code'
		label: 'Invitation Code'
		placeholder: '********'
	}
}

pub fn remember_input() CheckboxInput {
	return CheckboxInput {
		name: 'remember-me'
		required: false
		label: 'Remember me'
	}
}

pub struct TermsConditionsInput {
	link string
}

pub fn terms_conditions_input(input TermsConditionsInput) CheckboxInput {
	label := 'I accept the <a href="${input.link}" class="text-primary-700 hover:underline dark:text-primary-500">Terms and Conditions</a>'
	return CheckboxInput {
		name: 'terms-and-conditions'
		label: label
		required: true
	}
}

pub struct RememberInput {
pub:
	label       string
	name        string
	typ         string
	placeholder string
	required bool
}

// pub struct RegistrationInput {
// 	typ 
// }

// pub enum RegistrationInputType {

// }

// pub fn registration_input() InputWithLabel {
// 	return InputWithLabel {
// 		label: 'Referral Code'
// 		placeholder: '********'
// 	}
// }